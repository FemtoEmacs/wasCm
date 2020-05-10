const { readFileSync } = require("fs");

const run = async () => {
  const buffer = readFileSync("./tailfib.wasm");
  const module = await WebAssembly.compile(buffer);
  const instance = await WebAssembly.instantiate(module);
    console.log("=== Tail Recursion Elimination ===");
    console.log(instance.exports.fib(42, 1,1));
    console.log(instance.exports.ffib(5, 1.0, 1.0));
};

run();
