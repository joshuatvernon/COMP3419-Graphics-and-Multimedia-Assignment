# COMP3419 Graphics and Multimedia - Assignment

#### General
This is an individual assignment (Option-1) and worth 25% of the total assessment of this unit of study. In this assignment, you are required to program a short video involving digital video processing, compositing and 2D animation techniques. The output video is a piece of animation based on a provided video clip. You are welcome to use ANY programming languages to complete your assignment.

<p align="center">
    <img src="" alt="monkey-1">
    Figure 1.1: Some example scenes of the input video.
</p>

#### Main Objectives
##### Motion Capture
[5%] The body of a monkey is labelled with red markers. Segment the red markers/the monkey and use the coordinates of them to track the body motions. Some morphological operations might be needed to enhance the segmentation of the red markers. Alternative strategies can also be used for motion capturing, e.g., optical flow, boundary detection, etc. Design a data structure to represent the sequence of the captured body motions.

##### Replace Background and Marionette
[7.5%] Replace the blue background with your own dynamic background which can be programmed animations or a video. Render your own character to replace the moving monkey according to the captured motions in a new video. You should use the animation techniques (will be introduced in labs) to achieve this and simulate the gestures of the monkey as much as you could. The replaced character should have at least five connected components, including a body, two arms and two legs.

##### Intelligent Objects
[5%] Add at least two types of randomly moving objects to your video to interact with the moving marionette in two different ways (e.g. collision, tracking, etc.). The interactions are effected by the motions of both of the added objects and the marionette. 1 Trigger special effects when interactions happen using image processing techniques. More Intelligent objects are encouraged. The marking will depend on the design of intelligent objects and their interactions.

##### Sound Track
[2.5%] Program at least two sound tracks for your video. The sound tracks should be related to the
interactions between the moving objects.

##### Technical Report
[5%] Draft a 4-6 page technical report to demonstrate your pipeline. The main sections of report should at least include Introduction, Implementation and Conclusion. The implementation can discuss the algorithm and your experimental results. Your report should be written following the scientific style and formatted with LATEX. Do not panic about the LATEX and it has similar syntax like html. You can find a handy online latex editor at [https://www.sharelatex.com/](https://www.sharelatex.com/). An alternative choice is overleaf which can be found at [https://www.overleaf.com/](https://www.overleaf.com/).

##### Constraints
* The output video should have the same length as the provided video clip.
* The motions of your own character should be determined by the original marionette.
* The usage of libraries is only permitted for I/O purposes and low-level mathematical operations.

#####  Deliverables
All deliverables should be submitted via the e-Learning system. Your assignment will only be marked if all the deliverables can be accessed through e-Learning System. Late submission will not be accepted.
* All the related source code and a runnable demo program.
* A pdf technical report formatted with LATEX.
* A live demo in week 12 during the lab time and an example output video.
