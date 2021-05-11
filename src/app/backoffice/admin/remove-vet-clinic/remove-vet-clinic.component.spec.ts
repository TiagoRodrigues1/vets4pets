import { ComponentFixture, TestBed } from '@angular/core/testing';

import { RemoveVetClinicComponent } from './remove-vet-clinic.component';

describe('RemoveVetClinicComponent', () => {
  let component: RemoveVetClinicComponent;
  let fixture: ComponentFixture<RemoveVetClinicComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ RemoveVetClinicComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(RemoveVetClinicComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
