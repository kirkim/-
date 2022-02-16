import bcrypt from 'bcrypt';
import config from '../config.js';

export type User = {
  userID: string;
  password: string;
  name: string;
};

export type UserData = {
  data: User;
  id: string;
};
export type UserDatas = UserData[];

let userDatas: UserDatas = [
  {
    data: {
      userID: 'chichu',
      password: '$2b$12$onO6FjcLQx4ZHlpMgwzHg.2yAT9b6Jgde3ul6Jgr2CsUTza1JTqpm',
      name: 'Jisoo',
    },
    id: '1',
  },
  {
    data: {
      userID: 'Bob123',
      password: '$2b$12$onO6FjcLQx4ZHlpMgwzHg.2yAT9b6Jgde3ul6Jgr2CsUTza1JTqpm',
      name: 'Bob',
    },
    id: '2',
  },
];

async function hashPassword(password: string): Promise<string> {
  return await bcrypt.hash(password, config.bcrypt.saltRounds);
}

export async function create(user: User) {
  user.password = await hashPassword(user.password);
  const created = { data: user, id: Date.now().toString() };
  userDatas.push(created);
  return;
}

export async function findByUserID(userID: string): Promise<UserData | undefined> {
  return userDatas.find((user) => user.data.userID === userID);
}

export async function findByID(id: string): Promise<UserData | undefined> {
  return userDatas.find((user) => user.id === id);
}

export async function getAllUser(): Promise<UserDatas> {
  return userDatas;
}