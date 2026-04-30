#!/usr/bin/env python3
import json, os, sys

raw = sys.stdin.read()
try:
    data = json.loads(raw) if raw.strip() else {}
except json.JSONDecodeError:
    data = {}

model = (data.get("model") or {}).get("display_name") or "Claude"

ctx_size = 200000
if data.get("exceeds_200k_tokens"):
    ctx_size = 1000000

tokens = None
tpath = data.get("transcript_path")
if tpath and os.path.exists(tpath):
    last = None
    with open(tpath, "r", errors="replace") as f:
        for line in f:
            line = line.strip()
            if not line:
                continue
            try:
                rec = json.loads(line)
            except json.JSONDecodeError:
                continue
            msg = rec.get("message")
            if isinstance(msg, dict) and isinstance(msg.get("usage"), dict):
                last = msg["usage"]
    if last:
        tokens = (
            int(last.get("input_tokens") or 0)
            + int(last.get("cache_creation_input_tokens") or 0)
            + int(last.get("cache_read_input_tokens") or 0)
        )

def fmt(n):
    if n >= 1000:
        return f"{n/1000:.1f}k"
    return str(n)

if tokens is not None and ctx_size > 0:
    pct = round(tokens / ctx_size * 100)
    ctx_str = f"ctx: {fmt(tokens)}/{fmt(ctx_size)} ({pct}%)"
else:
    ctx_str = "ctx: --"

print(f"{model}  {ctx_str}", end="")
