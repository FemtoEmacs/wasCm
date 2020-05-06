const { readFileSync } = require("fs");

const run = async () => {
  const buffer = readFileSync("./fib.wasm");
  const module = await WebAssembly.compile(buffer);
  const instance = await WebAssembly.instantiate(module);
  console.log("=== Solução correta ===");
  console.log(instance.exports.fb(40));
};

run();
