import { Component, Inject, OnInit, PLATFORM_ID } from '@angular/core';
import { RouterOutlet } from '@angular/router';
import { CommonModule, isPlatformBrowser } from '@angular/common';
import type { Data } from '../@types/data';
import { APP_INITIAL_DATA } from '../app.token';
@Component({
  selector: 'app-root',
  standalone: true,
  imports: [CommonModule, RouterOutlet],
  templateUrl: './app.component.html',
  styleUrl: './app.component.scss'
})
export class AppComponent implements OnInit {
  data!: Data;

  isBrowser!: boolean;
  constructor(@Inject(PLATFORM_ID) private platformId: Object) {

  }
  title = 'yon';
  ngOnInit() {
    console.log(this.data);

    this.isBrowser = isPlatformBrowser(this.platformId);
  }
}
