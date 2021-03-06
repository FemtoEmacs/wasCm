const { readFileSync } = require("fs");

const run = async () => {
  const buffer = readFileSync("./fib.wasm");
  const module = await WebAssembly.compile(buffer);
  const instance = await WebAssembly.instantiate(module);
  console.log("Fibonacci(40)=", instance.exports.fib(40));
};

run();
