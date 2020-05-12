// File: ffibclient.js

const { readFileSync } = require("fs");

const run = async () => {
  const buffer = readFileSync("./ffib.wasm");
  const module = await WebAssembly.compile(buffer);
  const instance = await WebAssembly.instantiate(module);
  console.log("Fib(40)=", instance.exports.fib(40.0));};

run();
