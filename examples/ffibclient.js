const { readFileSync } = require("fs");

const run = async () => {
  const buffer = readFileSync("./ffib.wasm");
  const module = await WebAssembly.compile(buffer);
  const instance = await WebAssembly.instantiate(module);
  console.log("=== Solução correta ===");
  console.log(instance.exports.fib(40.0));
};

run();
