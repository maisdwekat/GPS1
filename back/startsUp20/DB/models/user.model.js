import { Types, Schema, model } from "mongoose";

const userSchema = new Schema({
    name: {
        type: String,
        required: true,
        trim: true
    },
    email: {
        type: String,
        required: true,
        unique: true
    },
    password: {
        type: String,
        required: true
    },
    phoneNumber: {
        type: String,
        required: false
    },
    gender: {
        type: String,
        default: 'male',
        enum: ['male', 'female']
    },
    role: {
        type: String,
        default: 'user',
        enum: ['user', 'admin', 'investor']
    },
    confirmEmail: {
        type: Boolean,
        default: false
    },
    image: {
        type: String,
        required: false,
    },
    sendCode: {
        type: String,
        default: null
    },
    lastLogin: { type: Date, default: null },
    fcmToken: { 
        type: String,
        
        default: null
    },
  
}, { timestamps: true });

const userModel = model('user', userSchema);

export { userModel };
