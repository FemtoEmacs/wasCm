const { readFileSync } = require("fs");

const run = async () => {
  const buffer = readFileSync("./mul.wasm");
  const module = await WebAssembly.compile(buffer);
  const instance = await WebAssembly.instantiate(module);
  console.log("=== Solução correta ===");
    console.log(instance.exports.multiply(40.8, 25.5));
};

run();
