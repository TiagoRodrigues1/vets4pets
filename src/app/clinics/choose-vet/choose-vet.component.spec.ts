import { ComponentFixture, TestBed } from '@angular/core/testing';

import { ChooseVetComponent } from './choose-vet.component';

describe('ChooseVetComponent', () => {
  let component: ChooseVetComponent;
  let fixture: ComponentFixture<ChooseVetComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ ChooseVetComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(ChooseVetComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
