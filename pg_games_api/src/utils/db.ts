import mongoose from "mongoose";

const connectDB = async (): Promise<void> => {
  try {
    const conn = await mongoose.connect(process.env.MONGO_URI || "", {
    });
    if (!conn) {
      throw new Error("Failed to connect to MongoDB");
    }
    // Optional: Set the connection to use the new URL parser and unified topology
    mongoose.set("strictQuery", false);
    mongoose.set("debug", true); // Enable debug mode for Mongoose
    console.log(`MongoDB Connected: ${conn.connection.host}`);
  } catch (error) {
    if (error instanceof Error) {
      console.error(`Error: ${error.message}`);
    } else {
      console.error("An unknown error occurred");
    }
    process.exit(1);
  }
};

export default connectDB;
