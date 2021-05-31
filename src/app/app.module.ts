import { HttpClientModule, HTTP_INTERCEPTORS } from '@angular/common/http';
import { NgModule } from '@angular/core';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { BrowserModule } from '@angular/platform-browser';

import { AppRoutingModule } from './app-routing.module';
import { AppComponent } from './app.component';
import { ErrorInterceptor } from './helpers/error.interceptor';
import { JwtInterceptor } from './helpers/jwt.interceptor';
import { HomeComponent } from './home/home.component';
import { BrowserAnimationsModule } from '@angular/platform-browser/animations';
import { MatFormFieldModule} from '@angular/material/form-field';

import { MatSidenavModule} from '@angular/material/sidenav';
import { MatToolbarModule} from '@angular/material/toolbar';
import { MatIconModule} from '@angular/material/icon';
import { HeaderComponent } from './components/header/header.component';
import { LeftMenuComponent } from './components/left-menu/left-menu.component';
import { MatDividerModule} from '@angular/material/divider';
import { MatListModule } from '@angular/material/list';
import { MatButtonModule } from '@angular/material/button';
import { RouterModule } from '@angular/router';
import { PetsComponent } from './pets/pets.component';
import { MatCardModule } from '@angular/material/card';
import { AddPetComponent } from './add-pet/add-pet.component';
import { MatInputModule } from '@angular/material/input';
import { MatDialogModule } from '@angular/material/dialog';
import { MatGridListModule } from '@angular/material/grid-list';
import { MatDatepickerModule } from '@angular/material/datepicker';
import { MatSelectModule } from '@angular/material/select';
import { MatRadioModule } from '@angular/material/radio';
import { ClinicComponent } from './clinics/clinic/clinic.component';
import { ClinicProfileComponent } from './clinics/clinic-profile/clinic-profile.component';
import { MatNativeDateModule } from '@angular/material/core';
import { ChoosePetComponent } from './clinics/choose-pet/choose-pet.component';
import { MatSortModule } from "@angular/material/sort";
import { MatPaginatorModule } from "@angular/material/paginator";
import { MatProgressSpinnerModule } from "@angular/material/progress-spinner";
import { MatTableModule } from "@angular/material/table";
import { VetComponent } from './backoffice/vet/vet.component';
import { ManagerComponent } from './backoffice/manager/manager.component';
import { AdminComponent } from './backoffice/admin/admin.component';
import { AddClinicComponent } from './backoffice/admin/add-clinic/add-clinic.component';
import { ManageAppointmentComponent } from './backoffice/vet/manage-appointment/manage-appointment.component';
import { NgbModule } from '@ng-bootstrap/ng-bootstrap';
import { FullCalendarModule } from '@fullcalendar/angular';
import dayGridPlugin from '@fullcalendar/daygrid'; // a plugin
import interactionPlugin from '@fullcalendar/interaction';
import { UserProfileComponent } from './user/user-profile/user-profile.component';
import { EditUserProfileComponent } from './user/edit-user-profile/edit-user-profile.component';
import { EditUserComponent } from './backoffice/admin/edit-user/edit-user.component';
import { DisplayAppointmentComponent } from './user/display-appointment/display-appointment.component';
import { AppointmentDetailsComponent } from './user/appointment-details/appointment-details.component';
import { AlertComponent } from './user/alert/alert.component';
import { DeletePetComponent } from './pets/delete-pet/delete-pet.component';
import { PetProfileComponent } from './pets/pet-profile/pet-profile.component';
import { ShowVaccinesComponent } from './pets/show-vaccines/show-vaccines.component';
import { PipeVaccinePipe } from './pets/show-vaccines/pipe-vaccine.pipe';
import { NotFoundComponent } from './not-found/not-found.component';
import { AddVetClinicComponent } from './backoffice/admin/add-vet-clinic/add-vet-clinic.component';
import { RemoveVetClinicComponent } from './backoffice/admin/remove-vet-clinic/remove-vet-clinic.component';
import {MatTooltipModule} from '@angular/material/tooltip';
import {MatStepperModule} from '@angular/material/stepper';
import { AddVaccineComponent } from './backoffice/vet/add-vaccine/add-vaccine.component';
import { AppMaterialElevationDirective } from './clinics/clinic/app-material-elevation.directive';
import { AddadoptionComponent } from './adoptions/addadoption/addadoption.component';
import { DisplayadoptionComponent } from './adoptions/displayadoption/displayadoption.component';
import { LastadoptionsComponent } from './adoptions/lastadoptions/lastadoptions.component';
import { MyadoptionsComponent } from './adoptions/myadoptions/myadoptions.component';
FullCalendarModule.registerPlugins([ // register FullCalendar plugins
  dayGridPlugin,
  interactionPlugin
]);
@NgModule({
  declarations: [
    AppComponent,
    HomeComponent,
    HeaderComponent,
    LeftMenuComponent,
    PetsComponent,
    AddPetComponent,
    ClinicComponent,
    ClinicProfileComponent,
    ChoosePetComponent,
    AdminComponent,
    VetComponent,
    ManagerComponent,
    AddClinicComponent,
    ManageAppointmentComponent,
    UserProfileComponent,
    EditUserProfileComponent,
    EditUserComponent,
    DisplayAppointmentComponent,
    AppointmentDetailsComponent,
    AlertComponent,
    DeletePetComponent,
    PetProfileComponent,
    ShowVaccinesComponent,
    PipeVaccinePipe,
    NotFoundComponent,
    AddVetClinicComponent,
    RemoveVetClinicComponent,
    AddVaccineComponent,
    AppMaterialElevationDirective,
    AddadoptionComponent,
    DisplayadoptionComponent,
    LastadoptionsComponent,
    MyadoptionsComponent
  ],
  imports: [
    BrowserModule,
    AppRoutingModule,
    HttpClientModule,
    ReactiveFormsModule,
    MatFormFieldModule,
    BrowserAnimationsModule,
    MatSidenavModule,
    MatToolbarModule,
    MatIconModule,
    MatDividerModule,
    MatListModule,
    MatButtonModule,
    RouterModule,
    MatCardModule,    
    MatInputModule,
    MatDialogModule,
    MatGridListModule,
    MatDatepickerModule,
    MatSelectModule,
    MatRadioModule,
    MatNativeDateModule,
    MatPaginatorModule, 
    MatProgressSpinnerModule, 
    MatSortModule, 
    MatTableModule,
    NgbModule,
    FullCalendarModule,
    MatTooltipModule,
    MatStepperModule,
    FormsModule,
  ],
  providers: [
    { provide: HTTP_INTERCEPTORS, useClass: JwtInterceptor, multi: true },
    { provide: HTTP_INTERCEPTORS, useClass: ErrorInterceptor, multi: true },
    LeftMenuComponent], 
  exports: [
    HeaderComponent,
    LeftMenuComponent,
    AlertComponent],
  bootstrap: [AppComponent],
  entryComponents:[AddPetComponent]
})
export class AppModule { }
