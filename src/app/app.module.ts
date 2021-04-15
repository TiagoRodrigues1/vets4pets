import { HttpClientModule, HTTP_INTERCEPTORS } from '@angular/common/http';
import { NgModule } from '@angular/core';
import { ReactiveFormsModule } from '@angular/forms';
import { BrowserModule } from '@angular/platform-browser';

import { AppRoutingModule } from './app-routing.module';
import { AppComponent } from './app.component';
import { ErrorInterceptor } from './helpers/error.interceptor';
import { JwtInterceptor } from './helpers/jwt.interceptor';
import { HomeComponent } from './home/home.component';
import { BrowserAnimationsModule, NoopAnimationsModule } from '@angular/platform-browser/animations';
import { MatFormFieldModule} from '@angular/material/form-field';
import { MenuModule } from '@syncfusion/ej2-angular-navigations';
import { SidebarModule } from '@syncfusion/ej2-angular-navigations';
import { TreeViewModule } from '@syncfusion/ej2-angular-navigations';
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


@NgModule({
  declarations: [
    AppComponent,
    HomeComponent,
    HeaderComponent,
    LeftMenuComponent,
    PetsComponent,
  ],
  imports: [
    BrowserModule,
    AppRoutingModule,
    HttpClientModule,
    ReactiveFormsModule,
    MatFormFieldModule,
    BrowserAnimationsModule,
    MenuModule,
    SidebarModule,
    TreeViewModule,
    MatSidenavModule,
    MatToolbarModule,
    MatIconModule,
    MatDividerModule,
    MatListModule,
    MatButtonModule,
    NoopAnimationsModule,
    RouterModule,
    MatCardModule,    
  ],
  providers: [
    { provide: HTTP_INTERCEPTORS, useClass: JwtInterceptor, multi: true },
    { provide: HTTP_INTERCEPTORS, useClass: ErrorInterceptor, multi: true },
    LeftMenuComponent
  ], 
  exports: [
    HeaderComponent,
    LeftMenuComponent
  ],
  bootstrap: [AppComponent]
})
export class AppModule { }
