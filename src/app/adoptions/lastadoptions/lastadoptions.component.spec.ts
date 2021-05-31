import { ComponentFixture, TestBed } from '@angular/core/testing';

import { LastadoptionsComponent } from './lastadoptions.component';

describe('LastadoptionsComponent', () => {
  let component: LastadoptionsComponent;
  let fixture: ComponentFixture<LastadoptionsComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ LastadoptionsComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(LastadoptionsComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
