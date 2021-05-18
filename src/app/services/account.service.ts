import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { MatDialog } from '@angular/material/dialog';
import { Router } from '@angular/router';
import { Observable, throwError } from 'rxjs';
import { BehaviorSubject } from 'rxjs';
import { delay, map } from 'rxjs/operators';
import { environment } from 'src/environments/environment';
import { Appointment } from '../models/appointment.model';
import { Clinic } from '../models/clinic.model';
import { Pet } from '../models/pet.model';
import { User } from '../models/user.model';
import { Vaccines } from '../models/vaccines';
import { CustomValidatorService } from './custom-validator.service';

@Injectable({
  providedIn: 'root'
})
export class AccountService {
  private userSubject: BehaviorSubject<User>;
  public user: Observable<User>;
  u:User;
  constructor (
    private router: Router,private http: HttpClient,private dialogRef: MatDialog,private val:CustomValidatorService) {
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

getUserPic(id:number) {
  return this.http.get(`${environment.apiUrl}/userPic/${id}`);
}


logout() {
  // remove user from local storage and set current user to null
  this.dialogRef.closeAll();
  localStorage.removeItem('user');
  this.userSubject.next(null);
  this.router.navigate(['/account/login']);
}

register(user: User) {
  return this.http.post(`${environment.apiUrl}/auth/register`, user);
}
  
refreshToken() {
  return this.http.put<any>(`${environment.apiUrl}/auth/refresh_token`,{}, {withCredentials: true}).pipe(
    map((user) => {
      localStorage.setItem('user', JSON.stringify(user));
      this.userSubject.next(user);
      return user;
    }));
}

validateResetToken(token:string) {
  return this.http.post(`${environment.apiUrl}/auth/validate_reset_token`,{token})
}

forgotPassword(email:string) { 
  return this.http.post(`${environment.apiUrl}/auth/forgot_password`,{email});
}

resetPassword(token:string, password: string, passwordConfirm: string) {
  return this.http.post(`${environment.apiUrl}/auth/reset_password`,{token,password,passwordConfirm});
}

getPets(id: number): Observable<Pet[]> {
  return this.http.get<Pet[]>(`${environment.apiUrl}/userAnimals/${id}`);
}

createPet (pet : Pet) {
  return this.http.post(`${environment.apiUrl}/animal/`,pet);
}

deletePet(id: number) {
  return this.http.delete(`${environment.apiUrl}/animal/${id}`);
}

editPet(id:number, pet: Pet) {
  return this.http.put(`${environment.apiUrl}/animal/${id}`,pet);
}

getClinics():Observable<Clinic[]> {
  return this.http.get<Clinic[]>(`${environment.apiUrl}/clinic/`);
}

getVetByClinic(id:number):Observable<User[]> {
  return this.http.get<User[]>(`${environment.apiUrl}/vetsClinic/${id}`)
}

createAppointment(app:Appointment) {
  return this.http.post(`${environment.apiUrl}/appointment/`,app);
}

createClinic(clinic:Clinic) {
  return this.http.post(`${environment.apiUrl}/clinic/`,clinic);
}

editClinic(id:number, clinic: Clinic) {
  return this.http.put(`${environment.apiUrl}/clinic/${id}`,clinic); //falta fazer o endpoint
} 

deleteClinic(id:number) {
  return this.http.delete(`${environment.apiUrl}/clinic/${id}`);
}

getAppointmentByVet(id:number): Observable<Appointment[]> {
  return this.http.get<Appointment[]>(`${environment.apiUrl}/appointment/vet/${id}`)
}

 getAppointmentByVet2(id:number):Observable<Appointment[]> {
  return this.http.get<Appointment[]>(`${environment.apiUrl}/appointment/vet/${id}`).pipe(delay(1000));
}

getAppointment(id:number): Observable<Appointment> {
  return this.http.get<Appointment>(`${environment.apiUrl}/appointment/${id}`)
}

editAppointment(id:number, app: Appointment) {
  return this.http.put(`${environment.apiUrl}/appointment/${id}`,app)
}

getUsers(): Observable<User[]> {
  return this.http.get<User[]>(`${environment.apiUrl}/user/`)
}

getUsersNormal() : Observable<User[]> {
  return this.http.get<User[]>(`${environment.apiUrl}/userNormal/`)
}

getUsersVet(idClinic:number) : Observable<User[]> {
  return this.http.get<User[]>(`${environment.apiUrl}/userVet/${idClinic}`)
}

editUser(id:number, user:User) {
  return this.http.put(`${environment.apiUrl}/user/${id}`,user)
}

getUser(id:number): Observable<User> {
  return this.http.get<User>(`${environment.apiUrl}/user/`)
}

getAppointmentsUser(id:number) {
  return this.http.get(`${environment.apiUrl}/appointmentOfuser/${id}`)
}

getPet(id:number, userID: number): Observable<Pet> {
  return this.http.get<Pet>(`${environment.apiUrl}/animal/${id}/${userID}`)
}

getPetVet(id:number): Observable<Pet> {
  return this.http.get<Pet>(`${environment.apiUrl}/animal/${id}`)
}

getVaccinesByPet(id:number):Observable<Vaccines[]> {
  return this.http.get<Vaccines[]>(`${environment.apiUrl}/vaccine/${id}/`);
}

addVetToClinic(idUser:number,id:number,user:User) {
  return this.http.put(`${environment.apiUrl}/clinic/${id}/${idUser}`,user);
}

remVetClinic(idUser:number,user:User){
  return this.http.put(`${environment.apiUrl}/clinicRem/${idUser}`,user);
}



public get userValue(): User {
  return this.userSubject.value;
}

processError(err) {
  let message = '';
  if(err.error instanceof ErrorEvent) {
   message = err.error.message;
  } else {
   message = `Error Code: ${err.status}\nMessage: ${err.message}`;
  }
  console.log(message);
  return throwError(message);
}



}
