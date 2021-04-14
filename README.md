# Golf Scores

In an effort to win gazillions of dollars in fantasy golf, this app fetches PGA data
for upcoming tournaments on a player-by-player and stat-by-stat level in order to
calculate how strongly- or weakly-correlated each stat is with the final result of
the tournament. The idea is to find which stats are most predictive of success
and then choose the golfers who excel at those skills for one's fantasy lineup.

Thus far this hasn't made anyone any money, but we're getting there. Maybe.
Probably not. Who knows. Regardless it's been a fun challenge.

## How It Works

We use Nokogiri to scrape past results as well as stat-specific pages for whichever
tournament is coming up. By comparing the relative ranking of each golfer to how they
placed overall at the end of the same tournament in years past, we can calculate the
correlation coefficient using the Pearson correlation calculation gem. This work is
handled by Sidekiq and is kicked off by manually calling a specific method. At some
point it'd make sense to set up a job to automate that part of the work.
