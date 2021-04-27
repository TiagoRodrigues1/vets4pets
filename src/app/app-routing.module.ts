import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { AddPetComponent } from './add-pet/add-pet.component';
import { AdminComponent } from './backoffice/admin/admin.component';
import { VetComponent } from './backoffice/vet/vet.component';
import { ClinicProfileComponent } from './clinics/clinic-profile/clinic-profile.component';
import { ClinicComponent } from './clinics/clinic/clinic.component';
import { AuthGuard } from './helpers/auth.guard';
import { HomeComponent } from './home/home.component';
import { Roles } from './models/roles.enum';
import { PetsComponent } from './pets/pets.component';

const accountModule = () => import('./account/account.module').then(x => x.AccountModule);

const routes: Routes = [
  { path: '', component: HomeComponent, canActivate: [AuthGuard] },
  { path: 'account', loadChildren: accountModule },
  { path: 'pets', component: PetsComponent, canActivate: [AuthGuard]},
  { path: 'addPet', component: AddPetComponent, canActivate: [AuthGuard]},
  { path: 'clinic', component: ClinicComponent, canActivate: [AuthGuard]},
  { path: 'clinic/:id', component: ClinicProfileComponent, canActivate: [AuthGuard]},
  { path: 'admin',component: AdminComponent, canActivate:[AuthGuard], data: {roles: [Roles.Admin]}},
  { path: 'vet', component: VetComponent, canActivate:[AuthGuard], data: {roles: [Roles.Vet]}},
  { path: '**', redirectTo: '' }
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }
