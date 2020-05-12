const { readFileSync } = require("fs");

const run = async () => {
  const buffer = readFileSync("./mix.wasm");
  const module = await WebAssembly.compile(buffer);
  const instance = await WebAssembly.instantiate(module);
  console.log(instance.exports.mixed(40.8, 25.5, 5));
};

run();
