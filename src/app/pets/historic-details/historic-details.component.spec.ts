import { ComponentFixture, TestBed } from '@angular/core/testing';

import { HistoricDetailsComponent } from './historic-details.component';

describe('HistoricDetailsComponent', () => {
  let component: HistoricDetailsComponent;
  let fixture: ComponentFixture<HistoricDetailsComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ HistoricDetailsComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(HistoricDetailsComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
