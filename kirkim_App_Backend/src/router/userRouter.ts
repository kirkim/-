import express from 'express';
import * as userController from '../controller/userController.js';

const userRouter = express.Router();

userRouter.route('/login').post(userController.postLogin);
userRouter.route('/signup').post(userController.postSignUp);
userRouter.route('/checkid').post(userController.checkId);
userRouter.route('/').get(userController.getAllUser);
userRouter.route('/like').get(userController.getLikeStoresById);
userRouter.route('/toggleLike').put(userController.addOrRemoveLikeStore);

export default userRouter;
