import { ComponentFixture, TestBed } from '@angular/core/testing';

import { HistoricPetComponent } from './historic-pet.component';

describe('HistoricPetComponent', () => {
  let component: HistoricPetComponent;
  let fixture: ComponentFixture<HistoricPetComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ HistoricPetComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(HistoricPetComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
