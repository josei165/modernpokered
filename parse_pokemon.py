#!/usr/bin/env python3
"""
Parses data/pokemon/base_stats/*.asm and data/pokemon/evos_moves.asm
into a single pokemon.csv with one row per Pokemon.

Columns:
  name, hp, atk, def, spd, sat, sdf, type1, type2, catch_rate, base_exp,
  level1_learnset, growth_rate, tmhm_learnset, evolutions, moveset
"""

import csv
import os
import re
from pathlib import Path

BASE_STATS_DIR = Path("data/pokemon/base_stats")
EVOS_MOVES_FILE = Path("data/pokemon/evos_moves.asm")
OUTPUT_CSV = Path("pokemon.csv")


# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------

def clean_token(s: str) -> str:
    """Strip whitespace and inline comments from a token."""
    return s.split(";")[0].strip().strip("\\").strip()


def strip_comment(line: str) -> str:
    return line.split(";")[0].strip()


# ---------------------------------------------------------------------------
# Parse evos_moves.asm into a dict  {label_name: {"evos": [...], "moves": [...]}}
# The label name (e.g. KangaskhanEvosMoves) is the key.
# ---------------------------------------------------------------------------

def parse_evos_moves(path: Path) -> dict:
    data = {}
    current = None

    label_re = re.compile(r"^([A-Za-z0-9_]+)EvosMoves\s*:", re.IGNORECASE)

    # States inside a block
    in_evos = False
    in_moves = False

    for raw in path.read_text(encoding="utf-8", errors="replace").splitlines():
        line = raw.strip()

        # New label
        m = label_re.match(line)
        if m:
            current = m.group(1)  # e.g. "Kangaskhan"
            data[current] = {"evos": [], "moves": []}
            in_evos = True
            in_moves = False
            continue

        if current is None:
            continue

        # Section comments
        if "; Evolutions" in line:
            in_evos = True
            in_moves = False
            continue
        if "; Learnset" in line:
            in_evos = False
            in_moves = True
            continue

        code = strip_comment(line)
        if not code:
            continue

        # db 0  →  terminator for current section
        if code == "db 0":
            if in_evos:
                in_evos = False
                in_moves = True   # learnset always follows
            else:
                in_moves = False
                current = None
            continue

        if code.startswith("db "):
            args = [a.strip() for a in code[3:].split(",")]

            if in_evos and args:
                # Evolution entry: EVO_METHOD, ARG, TARGET  (or just TARGET)
                data[current]["evos"].append(" ".join(args))

            elif in_moves and len(args) == 2:
                level, move = args[0], args[1]
                data[current]["moves"].append(f"L{level}:{move}")

    return data


# ---------------------------------------------------------------------------
# Parse a single base_stats .asm file
# ---------------------------------------------------------------------------

STAT_FIELDS = ["hp", "atk", "def", "spd", "sat", "sdf"]

def parse_base_stat_file(path: Path) -> dict:
    lines = path.read_text(encoding="utf-8", errors="replace").splitlines()

    rec = {
        "name": path.stem,          # filename without extension
        "pokedex_id": "",
        "hp": "", "atk": "", "def": "", "spd": "", "sat": "", "sdf": "",
        "type1": "", "type2": "",
        "catch_rate": "",
        "base_exp": "",
        "level1_learnset": "",
        "growth_rate": "",
        "tmhm_learnset": "",
    }

    # We'll collect tm/hm moves across continuation lines
    in_tmhm = False
    tmhm_moves = []

    for raw in lines:
        line = raw.strip()
        code = strip_comment(line)

        # Pokedex id
        if code.startswith("db DEX_"):
            rec["pokedex_id"] = code.split("DEX_")[1].strip()
            continue

        # Base stats line: 6 numbers
        stat_match = re.match(
            r"db\s+(-?\d+)\s*,\s*(-?\d+)\s*,\s*(-?\d+)\s*,\s*(-?\d+)\s*,\s*(-?\d+)\s*,\s*(-?\d+)",
            code,
        )
        if stat_match and not rec["hp"]:
            for field, val in zip(STAT_FIELDS, stat_match.groups()):
                rec[field] = val
            continue

        # Types: db TYPE1, TYPE2  (after stats line is filled)
        # Identified by position (after stats) and being two ALL_CAPS identifiers.
        # PSYCHIC_TYPE is the special case; all others are bare names like ROCK, FLYING.
        type_match = re.match(r"db\s+([A-Z][A-Z0-9_]*)\s*,\s*([A-Z][A-Z0-9_]*)\s*$", code)
        if type_match and not rec["type1"] and rec["hp"]:
            t1, t2 = type_match.groups()
            rec["type1"] = t1.replace("_TYPE", "")
            rec["type2"] = t2.replace("_TYPE", "")
            continue

        # Catch rate
        if not rec["catch_rate"] and re.match(r"db\s+\d+\s*$", code):
            # Could be catch rate or base exp – catch rate comes first
            if not rec["base_exp"]:
                rec["catch_rate"] = code.split()[1]
                continue

        # Base exp (second lone db integer)
        if not rec["base_exp"] and re.match(r"db\s+\d+\s*$", code) and rec["catch_rate"]:
            rec["base_exp"] = code.split()[1]
            continue

        # Level-1 learnset
        if code.startswith("db ") and not rec["level1_learnset"] and rec["catch_rate"]:
            args = [a.strip() for a in code[3:].split(",")]
            # Looks like moves if all tokens are UPPER_CASE (no digits-only)
            if all(re.match(r"[A-Z][A-Z0-9_]*$", a) for a in args if a):
                rec["level1_learnset"] = ", ".join(args)
                continue

        # Growth rate
        if code.startswith("db GROWTH_"):
            rec["growth_rate"] = code.split("db ")[1].strip().replace("GROWTH_", "")
            continue

        # TM/HM block
        if code.startswith("tmhm "):
            in_tmhm = True
            moves_part = code[5:].rstrip("\\").strip()
            tmhm_moves.extend(m.strip() for m in moves_part.split(",") if m.strip())
            continue

        if in_tmhm:
            if "; end" in line or (not code and "; end" in raw):
                in_tmhm = False
                continue
            cleaned = code.rstrip("\\").strip()
            if cleaned:
                tmhm_moves.extend(m.strip() for m in cleaned.split(",") if m.strip())
            continue

    rec["tmhm_learnset"] = ", ".join(tmhm_moves)
    return rec


# ---------------------------------------------------------------------------
# Match base_stat filename → evos_moves label
# Strategy: case-insensitive exact match after stripping underscores/spaces.
# ---------------------------------------------------------------------------

def build_name_map(evos: dict) -> dict:
    """Return {normalised_key: original_label}"""
    return {k.lower().replace("_", ""): k for k in evos}


def find_evos_label(pokemon_name: str, name_map: dict) -> str | None:
    key = pokemon_name.lower().replace("_", "").replace(" ", "")
    return name_map.get(key)


# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------

def main():
    if not BASE_STATS_DIR.exists():
        raise FileNotFoundError(f"Directory not found: {BASE_STATS_DIR}")
    if not EVOS_MOVES_FILE.exists():
        raise FileNotFoundError(f"File not found: {EVOS_MOVES_FILE}")

    print(f"Parsing {EVOS_MOVES_FILE} ...")
    evos_data = parse_evos_moves(EVOS_MOVES_FILE)
    name_map = build_name_map(evos_data)
    print(f"  Found {len(evos_data)} EvosMoves entries.")

    asm_files = sorted(BASE_STATS_DIR.glob("*.asm"))
    print(f"Parsing {len(asm_files)} base_stats files ...")

    rows = []
    unmatched = []

    for f in asm_files:
        rec = parse_base_stat_file(f)
        label = find_evos_label(rec["name"], name_map)

        if label:
            entry = evos_data[label]
            rec["evolutions"] = " | ".join(entry["evos"]) if entry["evos"] else "None"
            rec["moveset"] = ", ".join(entry["moves"]) if entry["moves"] else ""
        else:
            rec["evolutions"] = ""
            rec["moveset"] = ""
            unmatched.append(rec["name"])

        rows.append(rec)

    if unmatched:
        print(f"  WARNING – no EvosMoves match for: {', '.join(unmatched)}")

    fieldnames = [
        "name", "pokedex_id",
        "hp", "atk", "def", "spd", "sat", "sdf",
        "type1", "type2",
        "catch_rate", "base_exp",
        "level1_learnset", "growth_rate", "tmhm_learnset",
        "evolutions", "moveset",
    ]

    with OUTPUT_CSV.open("w", newline="", encoding="utf-8") as fh:
        writer = csv.DictWriter(fh, fieldnames=fieldnames, extrasaction="ignore")
        writer.writeheader()
        writer.writerows(rows)

    print(f"Done! Written {len(rows)} rows → {OUTPUT_CSV}")


if __name__ == "__main__":
    main()