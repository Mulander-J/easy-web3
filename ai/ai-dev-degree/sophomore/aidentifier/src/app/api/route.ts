import { NextRequest, NextResponse } from "next/server";

// Create a POST API Route
export async function POST(req: NextRequest) {
  // Extract `theImage` sent from the frontend
  const formData = await req.formData();
  const theImage = formData.get("theImage");

  // Make a call to Hugging Face using the API Key we got from there
  const response = await fetch(
    "https://api-inference.huggingface.co/models/facebook/detr-resnet-50-panoptic",
    {
      headers: { 
        Authorization: `Bearer ${process.env.HF_APIKEY}`,
        'x-use-cache': 'false'
      },
      method: "POST",
      body: theImage,
    }
  );

  // Get the response body
  const result = await response.json();

  console.log('result', result)

  // Forward the response back to the frontend
  return NextResponse.json({ body: result });
}