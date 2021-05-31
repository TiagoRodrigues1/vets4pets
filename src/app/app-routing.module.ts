import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { AddPetComponent } from './add-pet/add-pet.component';
import { AdminComponent } from './backoffice/admin/admin.component';
import { ManagerComponent } from './backoffice/manager/manager.component';
import { VetComponent } from './backoffice/vet/vet.component';
import { ClinicProfileComponent } from './clinics/clinic-profile/clinic-profile.component';
import { ClinicComponent } from './clinics/clinic/clinic.component';
import { AuthGuard } from './helpers/auth.guard';
import { HomeComponent } from './home/home.component';
import { Roles } from './models/roles.enum';
import { NotFoundComponent } from './not-found/not-found.component';
import { PetProfileComponent } from './pets/pet-profile/pet-profile.component';
import { PetsComponent } from './pets/pets.component';
import { UserProfileComponent } from './user/user-profile/user-profile.component';

const accountModule = () => import('./account/account.module').then(x => x.AccountModule);

const routes: Routes = [
  { path: '', component: HomeComponent, canActivate: [AuthGuard] },
  { path: 'account', loadChildren: accountModule },
  { path: 'pets', component: PetsComponent, canActivate: [AuthGuard],data: {roles: [Roles.User, Roles.Manager]}},
  { path: 'pets/:id', component: PetProfileComponent , canActivate: [AuthGuard],data: {roles: [Roles.User, Roles.Manager]}},
  { path: 'addPet', component: AddPetComponent, canActivate: [AuthGuard],data: {roles: [Roles.User, Roles.Manager]}},
  { path: 'clinic', component: ClinicComponent, canActivate: [AuthGuard],data: {roles: [Roles.User, Roles.Manager]}},
  { path: 'clinic/:id', component: ClinicProfileComponent, canActivate: [AuthGuard],data: {roles: [Roles.User, Roles.Manager]}},
  { path: 'admin',component: AdminComponent, canActivate:[AuthGuard], data: {roles: [Roles.Admin]}},
  { path: 'vet', component: VetComponent, canActivate:[AuthGuard], data: {roles: [Roles.Vet]}},
  { path: 'manager', component: ManagerComponent, canActivate:[AuthGuard], data: {roles: [Roles.Manager]}},
  { path: 'userprofile',component: UserProfileComponent, canActivate:[AuthGuard]},
  { path: '404', component:NotFoundComponent},
  { path: '**', component:NotFoundComponent}
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }
