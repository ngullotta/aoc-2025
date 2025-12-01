// https://adventofcode.com/2025/day/1

import { TextLineStream } from "jsr:@std/streams/text-line-stream";

const filename = Deno.args[0];

if (!filename) {
  Deno.exit(1);
}

using file = await Deno.open(filename, { read: true });

const lines = file.readable
  .pipeThrough(new TextDecoderStream())
  .pipeThrough(new TextLineStream());

let c1 = 0;
let c2 = 0;
let pos = 50;
const M = 100;

for await (const line of lines) {
  if (line.trim().length === 0) continue;

  const dir = line.charAt(0);
  const predicate = line.substring(1);

  let n = parseInt(predicate, 10);

  if (isNaN(n)) {
    console.error(`Error parsing '${predicate}'`);
    continue;
  }

  const raw = pos + (dir === "L" ? -1 : 1) * n;

  c2 += Math.floor(Math.abs(raw) / M) + Number(pos > 0 && raw <= 0);
  pos = (raw % M + M) % M;
  if (pos === 0) {
    c1++;
  }
}

// Valid answers
// > 2caa7092e551b084393096907fa1069957f6a64e32e6ae1e796b6b27da31b0e7  data/1.txt
// c1 = 1158
// c2 = 6860

console.log(c1, c2);
