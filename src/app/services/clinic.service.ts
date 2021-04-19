import { Injectable } from '@angular/core';
import { Clinic } from '../models/clinic.model';

@Injectable({
  providedIn: 'root'
})
export class ClinicService {
  clinic : Clinic;
  
  constructor() { }
}
