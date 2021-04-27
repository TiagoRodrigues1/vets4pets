import {Roles} from './roles.enum';
export class User {
    id: string;
    username: string;
    password: string;
    email:string;
    name: string;
    birthday: Date;
    gender: boolean;
    contact: string;
    userType: Roles;
    token: string;
}
