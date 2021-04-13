import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Router } from '@angular/router';
import { Observable } from 'rxjs';
import { BehaviorSubject } from 'rxjs';
import { map } from 'rxjs/operators';
import { environment } from 'src/environments/environment';
import { User } from '../models/user.model';

@Injectable({
  providedIn: 'root'
})
export class AccountService {
  private userSubject: BehaviorSubject<User>;
  public user: Observable<User>;

  constructor(
    private router: Router,private http: HttpClient) {
    this.userSubject = new BehaviorSubject<User>(JSON.parse(localStorage.getItem('user')));
    this.user = this.userSubject.asObservable();
}

login(email, password) {
  return this.http.post<User>(`${environment.apiUrl}/auth/login`, { email, password })
      .pipe(map(user => {
          // store user details and jwt token in local storage to keep user logged in between page refreshes
          localStorage.setItem('user', JSON.stringify(user));
          this.userSubject.next(user);
          return user;
      }));
}

logout() {
  // remove user from local storage and set current user to null
  localStorage.removeItem('user');
  this.userSubject.next(null);
  this.router.navigate(['/account/login']);
}

register(user: User) {
  return this.http.post(`${environment.apiUrl}/auth/register`, user);
}
  public get userValue(): User {
    return this.userSubject.value;
}

}
