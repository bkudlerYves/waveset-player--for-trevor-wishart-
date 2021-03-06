//you will have to start with waveset-player and drop in files to convert tow wavesets.

//put the path to the waveset-player file here and load it in. This will store an event in the currentEnvironment called "wavesetPlayer"
().load

//A bunch of different waveforms are included in this file. This waveSetPlayer needs a Key:Value store (event) of waves injected into it and then needs to do some initalize type stuff, and then needs to create buffers for doing some of the transformations, do that all here.
(
~waveSetPlayer.waves = ~wavesetWaves;
~waveSetPlayer.init;
//subBuf will be buffer 20;
~waveSetPlayer.initBuffer(20);
);

(
//send a random wave from the waves you injected into waveSetPlayer to the subBuf so you have waveforms to substitute in later... just trust me.
~waveSetPlayer.randomWave();
//plot it;
~waveSetPlayer.subBuf.plot;
)

//start playing the wavesets from your current waveset signal back
~waveSetPlayer.go(100).play;
//I added in a basic limiter for convenience, everything is routed through it, you can change how it works in the other file or you can change the out of the waveset SynthDefs and then do whatever you want.
~waveSetPlayer.out = 5;
Synth(\eq,addAction:\addToTail);

//bigger numbers louder for each
~waveSetPlayer.setAmpAmt(2);
//this makes things louder more quicly
~waveSetPlayer.setAmpAdd(2);

//back to normal
~waveSetPlayer.setAmpAmt(1);
~waveSetPlayer.setAmpAdd(1);

//if you want to change the current waveset you're using
~waveSetPlayer.switchSet = true;
~temp = ~waveSetPlayer.currSet
~waveSetPlayer.switchToSet = Wavesets.from("");
//switches it back to the original waveset
~waveSetPlayer.switchToSet = ~temp;
~waveSetPlayer.switchSet = false;

//change the instrument being used to play the individual wavesets, this will modulate the starting point as each waveset is being played
~waveSetPlayer.modulateStart();
//frequency of modulation
~waveSetPlayer.startModFreq = 0.2;
//the range of modulation, 1 is modulation from current starting point to current start + current start to current start - current start. 0.5 is is modulation from current start to currentStart + current start * 0.5 to currentStart - current start * 0.5 etc...
~waveSetPlayer.startAmt = 1;

//change the instrument being used to play the individual wavesets, this will modulate the speed of the waveset as each is being played
~waveSetPlayer.modulateSpeed();
~waveSetPlayer.speed2 = 2.5;

//both speed and start modulation
~waveSetPlayer.moduleSpeedPlusStart()

//back to regular instrument
~waveSetPlayer.resetInst();

//put a small amount of distnace between each waveset, or a lot if you want...
//0.05 will make a lot of noise, 0.001 will make a little, numbers between 0.0001 - 0.5 are recommended
~waveSetPlayer.distance = {0.05};
//back to normal
~waveSetPlayer.distance = {0};

//weird bit of my own thing, every speedChangeModuloth waveset, in this case every 8th waveset
//change the speed to speed + ((i%self.speedMod()) * self.plusAmount());
//example this would be every 8th waveset make speed be (say it is waveset number 64) 64%20*0.01 which equals 0.04
~waveSetPlayer.speedChangeModulo = 8;
~waveSetPlayer.plusAmount = 0.01;
~waveSetPlayer.speedMod = 20;
~waveSetPlayer.speedChangeModulo = ~waveSetPlayer.currSet.xings.size*2;

//change the amount of wavesets played for every waveset, so play 5 wavesets in the space of 1 waveset.
~waveSetPlayer.waveSetAmount = {5};
~waveSetPlayer.waveSetAmount = {1};

//waveset "transposition". Play N copies of a waveset in the space of M wavesets. This will alter the length that the waveset is played by the multiple, for example take twice the length to play one waveset for 2 or take half the time to play the waveset if multiplier is 0.5.
~waveSetPlayer.multiplier = {2};
~waveSetPlayer.multiplier = {1};

//waveset "omission", don't play every deleteAmountth waveset, in this instant every 3rd waveset. If deletePause is true it will insert silence the length of the waveset that is being "deleted", if false it won't. keep it under 50 probably, but try harder, maybe.
~waveSetPlayer.deleteAmount = 3;
~waveSetPlayer.deletePause = true;
~waveSetPlayer.deletePause = false;
//back to normal
~waveSetPlayer.deleteAmount = ~waveSetPlayer.currSet.xings.size*2;

//waveset "time stretching" play each waveset repeats amount of time, in this case play each waveset 3 times
~waveSetPlayer.repeats = 3;
//back to normal
~waveSetPlayer.repeats = 1;

//change the playback speed of each waveset. above 1 is faster below 1 is slower;
~waveSetPlayer.baseSpeed  = 1.4;
//back to normal
~waveSetPlayer.baseSpeed  = 1;

//waveset "averaging", play every averageModuloth waveset for the average length and at the average amplitude for the entire signal that the wavesets were generated from. This example plays every single waveset for the average lenght and at the average amplitude
~waveSetPlayer.shouldAverage = true;
~waveSetPlayer.averageModulo = 0;
//back to normal
~waveSetPlayer.shouldAverage = false;

//waveset "shaking", changes the length of every other waveset, by dividing (rather than multiplying) by the current multiplier, for instance if multiplier is 3 divide every even waveset by 3 and multiply every odd waveset by 3
~waveSetPlayer.shouldSwap = true;
//back to normal
~waveSetPlayer.shouldSwap = false;

//waveset "shuffling", play a waveset that is random distance from 0 to shuffAmount from the current waveset, for instance if you are at waveset number 200, this will play a random waveset from 170 to 200, this causes distortions, higher numbers is more distortions.... don't go too high, maybe a quarter of the number of wavesets at max
~waveSetPlayer.shouldShuffle = true;
~waveSetPlayer.shuffAmount = 30;
//back to normal
~waveSetPlayer.shouldShuffle = false;

//waveset "substitution”, substitute a waveform in the place of the current waveset. In this current example it will substitute for 200 wavesets then it will not substitute for 20 wavesets. mess with the ratios, any amount can be cool, 0 for subNormLevel will substitute every single waveset
~waveSetPlayer.shouldSub = {true};
~waveSetPlayer.subLevel = {200};
~waveSetPlayer.subNormLevel = {20};
//back to normal
~waveSetPlayer.shouldSub = {false};

//if you are substituting this will send a random waveform to the buffer that is being used for substituting every waveSubModth, this changes the waveform every 20 wavesets
~waveSetPlayer.waveSubMod = 20;
//back to normal
~waveSetPlayer.waveSubMod = ~waveSetPlayer.currSet.xings.size*2;

//waveset "reversal" reverses reverseLevel amount of wavesets and then doesn't for reverseNormLevel amount of wavesets. This examples will reverse 500 wavesets then not reverse 100.
~waveSetPlayer.shouldReverse = true;
~waveSetPlayer.reverseLevel = 500;
~waveSetPlayer.reverseNormLevel = 100;
//back to normal
~waveSetPlayer.shouldReverse = false;

//pan the wavesets to whatever pan is, in this example full right
~waveSetPlayer.pan = 1;
//this will start panning wavesets from pan*-1 to pan for every panLevel waveset.
~waveSetPlayer.shouldPan = true;
//this will play 3 wavesets at -1 and then 3 wavesets at 1
~waveSetPlayer.panLevel = 3;
~waveSetPlayer.panNormLevel = 3;
//this will play 700 wavesets at -1 and then 700 wavesets at 1
~waveSetPlayer.panLevel = 700;
~waveSetPlayer.panNormLevel = 700;
//back to normal
~waveSetPlayer.pan = 0;
~waveSetPlayer.shouldPan = false;

//at anytime you can override the buffer that is being used and just use the buffer for the current signal of wavesets you are looping through. This is useful sometimes when you are substituting or transfering it will make weird things happen
~waveSetPlayer.useCurrBuf = true;
//back to normal
~waveSetPlayer.useCurrBuf = false;

//this will decrement the amplitude every waveset and then pause for breakAmount seconds before starting up again at ampAmt level. This example will play 20 wavesets fading out to silence then pause for 0.3 seconds.
~waveSetPlayer.decBreak = true;
~waveSetPlayer.breakPointSet = 20;
~waveSetPlayer.breakAmount = 0.3;
//back to normal
~waveSetPlayer.decBreak = false;

//waveset "harmonic distortion". suerperimposes n harmonix on the waveset fundamental with a scaling fact m relative to the previous harmonic. The amplitude of each harmonic can be changed with harmLevel. 3 "harmonics" (copy of the waveset with faster playback speeds) are created, the amplitude of each is the original wavesets amplitude divided by the harmonic number, (numbers 2 through 4, i.e. 2,3,4) multiplied by the harmLevel. In this example the second harmonic's amplitude will be the amplitude of the current waveset divided by 3*0.1, etc... lower harmLevels means more pronounced (louder) harmonics and so on, larger means less pronounced.
//say the amp of the current waveset is 0.8, the amplitude of the first harmonic would be 0.8/(2*0.1).
//never go above one for harmLevel
//like sub and pan before, it will harmonize harmonizeLevel wavesets and then not harmonize harmonizeNormLevel amount of wavesets, in this case harmonize 50 wavesets then don't 20 wavesets
~waveSetPlayer.shouldHarmonize = true;
~waveSetPlayer.harmLevel = 0.1;
~waveSetPlayer.harmonizeLevel = 50;
~waveSetPlayer.harmonizeNormLevel = 20;
//back to normal
~waveSetPlayer.shouldHarmonize = false;

//waveset "transfer" method one. This will play a waveset from transferSet, length amp, sustain, using the currSet buffer (signal). Like the other level based transformations before it it will transfer for 9 wavesets and then not transfer for 11, set transferOneNormLevel to 0 for transfering every waveset
~waveSetPlayer.shouldTransferOne = true;
~waveSetPlayer.transferOneLevel = 9;
~waveSetPlayer.transferOneNormLevel = 11;
//back to normal
~waveSetPlayer.shouldTransferOne = false;

//waveset "transfer" method two. Same as above but it uses the length and sustain of the currSet signal and the length and sustain of the transferSet.
~waveSetPlayer.shouldTransferTwo = true;
~waveSetPlayer.transferTwoLevel = 300;
~waveSetPlayer.transferTwoNormLevel = 0;
//back to normal
~waveSetPlayer.shouldTransferTwo = false;

//waveset "interleaving" method one. Plays interleaveOneLevel amount of wavesets from leaveOneSet then interleaveOneNormLevel from the currSet, low numbers make a kind of waveset zipper effect and the sound gets confusing. Larger number creates a kind of fast crossfade thing, like one of the scratching dj assholes. The ratio of interleaveOneLevel to interleaveOneNormLevel  should be close to one for best effects, but maybe you like it less close
~waveSetPlayer.shouldInterleaveOne = true;
~waveSetPlayer.interleaveOneLevel = 2;
~waveSetPlayer.interleaveOneNormLevel = 2;
//back to normal
~waveSetPlayer.shouldInterleaveOne = false;

//waveset "interleaving" method two. Same as above but plays the corresponding waveset from interleaveTwoSet rather than just going forward. For instance it will play the tenth waveset from interleaveSetTwo and then the tenth waveset from interleaveSetOne, the above will play the tenth waveset then the eleventh. The ratio should also be close to one the zipper effect is more felt here and low numbers create psychocoustic effect of a totally blended signal.
~waveSetPlayer.shouldInterleaveTwo = true;
~waveSetPlayer.interleaveTwoLevel = 3;
~waveSetPlayer.interleaveTwoNormLevel = 3;
//back to normal
~waveSetPlayer.shouldInterleaveTwo = false;

//waveset "normalizing" normalize every waveset who's amplitude is above the average amplitude of the current waveset set times the normalizeThresh, so if the average is 0.8 every waveset that has an amplitude greater than 0.8*0.1, will be "normalized". Normalized means the wavesets amplitude is set to the average of the set. It will only check for every normalizeAmounth waveset, for example, this one only checks if it should normalize every second waveset.
~waveSetPlayer.shouldNormalize = true;
~waveSetPlayer.normalizeAmount = 2;
~waveSetPlayer.normalizeThresh = 0.1;
//back to normal
~waveSetPlayer.shouldNormalize = false;

//every speedSwapModuloth waveset, in this case every 3rd, gets it's speed multiplied by speedSwapAmt
~waveSetPlayer.speedSwapModulo = 3;
//higher numbers is faster. lower slower
~waveSetPlayer.speedSwapAmt = 0.5;
//back to normal
~waveSetPlayer.speedSwapModulo = ~waveSetPlayer.currSet.xings.size*2;

//waveset "shrinking" don't play every waveset who's amplitude is below the average amplitude times the shrinkAmt. In this example it will not play every waveset who's amplitude is less than 0.5 times the average
~waveSetPlayer.shouldShrink = true;
//higher numbers more shrinking
~waveSetPlayer.shrinkAmt = {0.5};
//back to normal
~waveSetPlayer.shouldShrink = false;

