import { Component } from '@angular/core';
import { GridMediaComponent } from '../../components/grid-media/grid-media.component';

@Component({
  selector: 'app-feed',
  standalone: true,
  imports: [GridMediaComponent],
  templateUrl: './feed.component.html',
  styleUrl: './feed.component.scss'
})
export class FeedComponent {

}
