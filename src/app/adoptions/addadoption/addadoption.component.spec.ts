import { ComponentFixture, TestBed } from '@angular/core/testing';

import { AddadoptionComponent } from './addadoption.component';

describe('AddadoptionComponent', () => {
  let component: AddadoptionComponent;
  let fixture: ComponentFixture<AddadoptionComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ AddadoptionComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(AddadoptionComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
