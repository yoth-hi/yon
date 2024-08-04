import { Routes } from '@angular/router';
import { FeedComponent } from './pages/feed/feed.component';
import { WatchComponent } from './pages/watch/watch.component';

export const routes: Routes = [
    { component: FeedComponent, path: "" },
    { component: WatchComponent, path: "watch" },
];
