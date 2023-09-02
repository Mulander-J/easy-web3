import sdk from "./1-initialize-sdk.js";
import { readFileSync } from "fs";

const bundleDrop = sdk.getBundleDropModule(
  "0xaC5970D6a9671444D9Ef8834c5465Dd851F8b542",
);

(async () => {
  try {
    await bundleDrop.createBatch([
      {
        name: "Snow Circle",
        description: "This NFT will give you access to FestDAO!",
        image: readFileSync("scripts/assets/snow.jpeg"),
      },
    ]);
    console.log("✅ Successfully created a new NFT in the drop!");
  } catch (error) {
    console.error("failed to create the new NFT", error);
  }
})()
// app  |    0x70395aBa80E5C46Fa526C99714aF1a9F5500ab65