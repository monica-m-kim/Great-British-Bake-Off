# The Great British Bake Off / The Great British Baking Show Dataset

### Background
Cooking and baking became a therapeutic practice during the pandemic.
Measuring flour, chopping ingredients, kneading the dough, resting, baking, and finally, indulging the beautiful creation that pops out of the oven boosts your mood. As a casual baker who baked pies, muffins, brownies, and cookies occasionally before the pandemic, I definitely increased the baking frequency and explored new recipes.

Late 2020, Netflix’s algorithm recommended The Great British Baking Show (Great British Bake Off or GBBO) which I am assuming it is based on historic records of watching holiday baking shows. GBBO has been around since 2010 but why didn’t I know about this earlier? I binge-watched the entire series available on Netflix. Watching contestant create something beautiful and appetizing boosted happiness that was much needed as a pandemic graduate/sad job seeker.

While I was rewatching ( I don’t recall how many times I rewatched… probably A LOT), Paul Hollywood, one of the judges of the show, mentioned that the Star Baker of Bread week always makes their way to the final. This sparked my curiosity. Is it a valid statement? Can this be a variable for guessing the winner? What are other variables? As a fresh grad with a Business Analytics degree, my initial move was to search for data sets. I found a comprehensive data set and worked on building models. I felt the need to build an extensive data set for broader analytical exploration but my focus shifted to new life events. Eventually, the project went dormant. 

Fast forward to 2022, new season started and it triggered me to revisit the GBBO data set. I expanded the data set with each row containing the outcome and ingredients used for each challenge for each baker, for each episode. Recording results was mild work. The real challenge was the ingredients. I listened to what the contestant and judges are saying, read the ingredients on screen, and watched the contestants’ baking table to write ingredients. Some seasons were no longer available on Netflix so I couldn’t record ingredients, unfortunately. 


### Data Sets
There are 5 data sets in this repository:

- gbbo_challengeresults: Result of each baker in each series along with signature bake ingredients, technical bake rank, and showstopper bake ingredients.
- gbbo_bakers: List of bakers of each series
- gbbo_judges: List of judges of each series
- gbbo_episodes: List of series, epsiodes, and episode names
- gbbo_judgeflavorpreference: Flavor preferred by judges 


### What work I have done
I have set up a SQL database to explore the data set while practicing mySQL statements. I am also utilizing Python to build models to predict winners and analyze ingredients/flavors to find the flavor combination that can increase the chance of winning.


### Ask for the community
- Please share questions you would like to know the answer. It is good practice for everyone!
- Share your version of mySQL statement to answer the questions. I would like to learn different approaches.
- Share your work with the data set. I would like to learn from you.
- This is my first time to build a public Github repository. Any suggestions for improvements are welcome!

If you have any questions/feed backs/requests, please reach out.
Monica Kim (monicakimx@gmail.com)

———

<sub> MIT License

<sub>Copyright (c) 2022 MINKYUNG KIM

<sub>Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

<sub>The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

<sub>THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
</sub>
