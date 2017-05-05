/*
 * StateMachine.cpp
 *
 *  Created on: 13 Jun 2016
 *  Author: Moises
 */

#include <autonomous_life/StateMachine.h>

std::string StateMachine::mood = "", StateMachine::emotion = "";
double StateMachine::maxLevel = 0, StateMachine::mPoints = 0, StateMachine::ePoints = 0;

/*
 * Initializes the StateMachine creating subscribers and clients and setting the starting emotion and mood
 * */
StateMachine::StateMachine() :
				speechClient("/speech_action"),
				setVocabularyClient("/speech_vocabulary_action"),
				behaviorClient("/run_behavior"),
				currentState(NULL)
{
	// Create subscribers and clients
	startRecognitionClient = nh.serviceClient<std_srvs::Empty>("/start_recognition");
	stopRecognitionClient = nh.serviceClient<std_srvs::Empty>("/stop_recognition");
	wordRecognizedSub = nh.subscribe("/word_recognized", 10, &StateMachine::onWordReceived, this);
	postureServiceClient = nh.serviceClient<naoqi_bridge_msgs::GetRobotPosture>("/get_robot_posture");
	tactileSub = nh.subscribe("/tactile_touch", 10, &StateMachine::onTouch, this);
	wordRecognizedSub = nh.subscribe("/word_recognized", 10, &StateMachine::onWordReceived, this);

	led_pub = nh.advertise<naoqi_bridge_msgs::FadeRGB>("fade_rgb", 1);
    ledMsg.fade_duration= ros::Duration(0.0);

	// Wait until all servers are ready
	speechClient.waitForServer();
	setVocabularyClient.waitForServer();

	startRecognitionClient.waitForExistence();
	stopRecognitionClient.waitForExistence();

	ROS_INFO("Starting autonomous life");

    srand(time(NULL));
    int total=0;
    double per=0, random=((double)(rand()%100)+1)/100;

    //Max Level set to 10, initial level for mood and emotion set to half of max (could be random)
    maxLevel=10, mPoints=maxLevel/2, ePoints=maxLevel/2;

    string moods[]={"NEUTRAL","TIRED","BORED","EXCITED"};   //Array of possible moods
    int moodsP[]={7,2,3,2};                                 //Array of likelihood for each mood (over 10)

    //Sum likelihoods to get total and calculate normalization
    for(int i=0; i<sizeof(moodsP)/4; i++) total+=moodsP[i];
    for(int i=0; mood.compare("") == 0 && i<sizeof(moodsP)/4; i++){
        per+=(double) moodsP[i]/total;
        if(random<per) mood=moods[i];
    }

    total=0;
    per=0, random=((double)(rand()%100)+1)/100;
    string emotions[]={"NEUTRAL","HAPPY","SAD","ANGRY"};    //Array of possible moods
    int emotionsP[]={7,6,3,2};                              //Array of likelihood for each emotion (over 10)

    //Sum likelihoods to get total and calculate normalization
    for(int i=0; i<sizeof(emotionsP)/4; i++) total+=emotionsP[i];
    for(int i=0; emotion.compare("")==0 && i<sizeof(emotionsP)/4; i++) {
        per+=(double) emotionsP[i]/total;
        if(random<per) emotion=emotions[i];
    }

    updateME(0);

    //Start the state machine
    transitionTo(new WaitInteraction());

}

StateMachine::~StateMachine() {
    if (currentState) {
        currentState->onLeave();
        currentState = NULL;
    }
}

const char * StateMachine::WaitInteraction::getName(){ return "WaitInteraction"; }

/*
 * State where it waits for an interaction (speech, touch or none (timeout))
 */
void StateMachine::WaitInteraction::onEnter(){
    //Print  out the mood, emotion and its levels for console feedback
    cout << "Robot: I am " << sm->mood <<"("<<sm->mPoints<<"), and I feel " << sm->emotion << "("<<sm->ePoints<<")"<<endl;

    //If emotion=angry, mood=bored, are both with max level then do [Huffing behaviour] and set emotion and mood points to 5 and mood to EXCITED
    if(sm->emotion.compare("ANGRY") == 0 && sm->mood.compare("BORED") == 0 && sm->mPoints >= sm->maxLevel && sm->ePoints >= sm->maxLevel){
    	sm->postureServiceClient.call(sm->posture.request, sm->posture.response);
    	if(sm->posture.response.posture.compare("Sit") == 0){
    		sm->doBehavior("animations/Sit/Emotions/Negative/Frustrated_1", 0, 0, 0.0);
    	}
    	else if(sm->posture.response.posture.compare("Standing") == 0){
    		sm->doBehavior("animations/Stand/Emotions/Negative/Angry_4", 0, 0, 0.0);
    	}
        sm->mood="EXCITED";
        sm->mPoints=5;
        sm->ePoints=5;
    }
    else{ //Wait for interaction
        cout <<"[Wait for interaction (listen, touch)]"<<endl;
        
        //Starts listening for the keyWords
        sm->listenFor("sing","dance","game");
        //Starts the faceTracking
        sm->startFaceTracker();
    }
}

/*
 * Listen for a set of words
 */
void StateMachine::listenFor(const char *word1, ...){
	va_list ap;
	va_start(ap, word1);
	naoqi_bridge_msgs::SetSpeechVocabularyGoal goal;
	int i=0;
	for(const char *word=word1;word!=NULL&&i<sizeof(word)/4;word=va_arg(ap, const char *),i++){
		goal.words.push_back(std::string(word));
	}
	va_end(ap);
	setVocabularyClient.sendGoalAndWait(goal);
	//Start listening
	std_srvs::Empty empty;
	startRecognitionClient.call(empty.request, empty.response);
}

/*
 * Sends a behavior goal by name without waiting
 */
void StateMachine::sendGoal(const std::string& goalName){
	naoqi_bridge_msgs::RunBehaviorGoal goal;
	goal.behavior = goalName;

	behaviorClient.sendGoal(goal);
}

/*
 * Send behavior goal by name and wait until it finish, it returns the state of the goal
 */
actionlib::SimpleClientGoalState StateMachine::sendGoalAndWait(const std::string& goalName){
	naoqi_bridge_msgs::RunBehaviorGoal goal;
	goal.behavior = goalName;

	actionlib::SimpleClientGoalState state = behaviorClient.sendGoalAndWait(goal);
	return state;
}

/*
 * Sends a message to speak without waiting
 */
void StateMachine::say(const std::string& text){
	naoqi_bridge_msgs::SpeechWithFeedbackGoal goal;
	ros::Duration wait_time(4.0);
	goal.say = text;
	speechClient.sendGoal(goal);
}

/*
 * Sends a goal to speak ad waits until it finish
 */
void StateMachine::sayAndWait(const std::string& text){
	naoqi_bridge_msgs::SpeechWithFeedbackGoal goal;
	ros::Duration wait_time(4.0);
	goal.say = text;
	speechClient.sendGoalAndWait(goal,wait_time,wait_time);
}

/*
 * Run a behavior by name turning the stiffness on before, and off after, it needs the emotion and mood points of the behavior and the duration
 * The duration can be set:
 * - lower than 0 to send the goal without waiting
 * - to 0 to send the goal and wait until it finish
 * - greater than 0 to send the goal and wait X duration to end it
 */
void StateMachine::doBehavior(string behaviorName, int ePoints, int mPoints, double duration){
	//If the name is not empty
	if(behaviorName.compare("") != 0){
		naoqi_bridge_msgs::RunBehaviorGoal goal;
		goal.behavior = behaviorName;

		//Turn on stiffness
		sendGoalAndWait("stiffness/StiffnessOn");

		//Check duration
		if(duration<0.0) behaviorClient.sendGoal(goal);
		else if(duration==0.0){
			actionlib::SimpleClientGoalState state = behaviorClient.sendGoalAndWait(goal);
			//Set stiffnessOff depending on the robot posture
			stiffnessOff();
		}
		else{
			actionlib::SimpleClientGoalState state = behaviorClient.sendGoalAndWait(goal,ros::Duration(duration));
			stiffnessOff();
		}
	}

	//Add the respective points
	this->ePoints+=ePoints;
	this->mPoints+=mPoints;
}

/*
 * Runs a random behavior depending on the emotion and mood by choosing the behavior from the behaviorsList (autonomous behavior)
 */
void StateMachine::doRandomBehavior(string emotionN, string moodN){
	string dialog;

	//If the posture could not be determined it shows an error
    if (!postureServiceClient.call(posture.request, posture.response)) {
    	ROS_ERROR("Could not determine current robot posture");
    }
    //Otherwise it runs the behavior
    else{
    	//If posture is crouch it makes the robot sit (There are no behaviors in crouch position in the behaviorsList yet)
		if(posture.response.posture.compare("Crouch") == 0){
			sendGoalAndWait("stiffness/StiffnessOn");
			sendGoalAndWait("ownanimations/SitDown");
			stiffnessOff();
		}//If posture is from the family of Standing and the robot posture is not "Stand" it makes him go to Stand posture
		else if(posture.response.family.compare("Standing") == 0 && posture.response.posture.compare("Stand") != 0){
			sendGoalAndWait("stiffness/StiffnessOn");
			sendGoalAndWait("ownanimations/StandUp");
		}

		//Gets the behavior name and points from the behavior list depending on the emotion, mood and posture
		tuple<string, int, int> behavior=chooseRandomBehavior(emotionN, moodN, posture.response.posture);

		//If the behavior name is not empty
		if(get<0>(behavior).compare("") != 0){
			sendGoalAndWait("stiffness/StiffnessOn");

			//Searches a dialog associated with that behavior name in the dialogsList
			dialog=chooseRandomDialog(get<0>(behavior));

			//If it finds one it sends the message to speak
			if(dialog.compare("[]") != 0) say(dialog);
			//Runs the behavior
			sendGoalAndWait(get<0>(behavior));
			stiffnessOff();
		}

		//Adds the points
		ePoints+=get<1>(behavior);
		mPoints+=get<2>(behavior);
    }
}

/*
 * Selects a random behavior from the autonomous behavior list depending on the emotion and mood
 */
void StateMachine::autonomousBehaviour(){
	string msg="";
	int nOp=1, prevEPoints=ePoints, prevMPoints=mPoints;
	bool action=true;
	std::mt19937 rng;
    rng.seed(std::random_device()());
    std::uniform_int_distribution<std::mt19937::result_type> dist6(0,100);
    double random = dist6(rng)/100.0;

	doRandomBehavior(emotion, mood);

	//If the random behavior didn't change the ePoints and mPoints
	if(ePoints==prevEPoints&&mPoints==prevMPoints){
		//Run a "RANDOM" type behavior with probability of 0.35
		if(random<0.35){
			doRandomBehavior("RANDOM", "");
		}

		//And increase the mPoints if it's bored (is more bored)
		if(mood.compare("BORED")==0){
	        mPoints++;
	    }//Else decrease the mPoints (Less tired, less excited, less neutral)
	    else mPoints--;
	}

    /*
       If emotion=NEUTRAL & ((emotions points<6 & (mood!=BORED || mood points<10)) || (mood=BORED & mLevel=10))
        If emotion is neutral lower its value only if mood is bored, and if mood value is not 10 only lower emotion value to 5
        This is so that the neutral emotion don't go down until the boredom is at some point, the value 10 could be changed to another "tolerance"
    */
    if(emotion.compare("NEUTRAL") == 0 && ((ePoints>5 && (mood.compare("BORED") != 0 || mPoints < 10))
                                           ||(mood.compare("BORED") == 0 && mPoints >= 10))){
        ePoints--;
    }
    else if(emotion.compare("ANGRY") == 0 && mood.compare("BORED") == 0 && mPoints >= 10){
        ePoints++;
    }
    else if((emotion.compare("NEUTRAL") != 0)){
        ePoints--;
    }

	updateME(0);
}

/*
 * It checks the posture to know whether or not it should turn off the motors to avoid that motors overheats
 */
void StateMachine::stiffnessOff(){
	postureServiceClient.call(posture.request, posture.response);
	if(postureServiceClient.call(posture.request, posture.response)&&posture.response.posture.find("Stand") != 0){
		sendGoalAndWait("stiffness/StiffnessOff");
	}
}

/*
 * It updates the mood and emotion depending on the likeliness of the last behavior, emotion points and mood points
 */
void StateMachine::updateME(int likelyness) {
	//Strings used as keyWord to select a random dialog from the dialogsList.txt
    string moodMsg="", emotionMsg="";

    /* States check
    low->around 0, high->around 10 */
    
    /* ///////////MOODS////////////
     * Tired<0 -> Neutral from low
     * Tired>=10 -> Max
     * Bored<0 -> Neutral from low
     * Bored>=10 -> Max
     * Neutral<0 -> Bored from low
     * Neutral>=10 -> Excited from low
     * Excited<0 -> Neutral from high
     * Excited>=10 -> Tired from low/high/middle?
     */
    
    //If mood = "mood"
    if(mood.compare("TIRED") == 0){
        //If level is lower than 0
        if(mPoints<=0){
            //Set new mood
            mood = "NEUTRAL";
            //Set new level
            //(e.g: if previous level was -2 of EXCITED, the new level would be NEUTRAL from high (maxLevel-2))
            //(e.g: if previous level was 12 of NEUTRAL, the new level would be EXCITED from low (0+2))
            mPoints = mPoints*-1+1;
            //Set the keyWord to select a random dialog
            moodMsg="Feel_rested_update";
        }
        //else if level is greater than 9
        else if(mPoints >= maxLevel) mPoints = maxLevel;
    }
    else if(mood.compare("BORED") == 0){
        if(mPoints<=0){
            mood = "NEUTRAL";
            mPoints = mPoints*-1+1;
            moodMsg="Not_bored_update";
        }
        else if(mPoints >= maxLevel) mPoints = maxLevel;
    }
    else if(mood.compare("NEUTRAL") == 0){
        if(mPoints<=0){
            mood = "BORED";
            mPoints = mPoints*-1+1;
            moodMsg="Feel_bored_update";
        }
        else if(mPoints >= maxLevel){
            mPoints = mPoints - maxLevel;
            mood = "EXCITED";
            moodMsg="Feel_excited_update";
        }
    }
    else if(mood.compare("EXCITED") == 0){
        if(mPoints<=0){
            mPoints = maxLevel+mPoints;
            mood = "NEUTRAL";
            moodMsg="Not_Excited_update";
        }
        else if(mPoints >= maxLevel){
            mPoints = maxLevel+mPoints;
            mood = "TIRED";
            moodMsg="Feel_tired_update";
            mPoints = maxLevel;
        }
    }
    
    /* ////////////EMOTIONS/////////////
     * Angry<0 -> Neutral from low
     * Angry>=10 -> Max
     * Sad<0 -> Neutral from low
     * Sad>=10 -> Max
     * Neutral<0 -> Random(Angry, Sad) unless mood=bored, then Angry
     * Neutral>=10 -> Happy from low
     * Happy<0 -> Neutral from high
     * Happy>=10 -> Max
     */
    
    if(emotion.compare("ANGRY") == 0){
        if(ePoints<=0){
            emotion = "NEUTRAL";
            ePoints = maxLevel+ePoints;
            emotionMsg="Not_angry_update";
        }
        else if(ePoints >= maxLevel) ePoints = maxLevel;
    }
    else if(emotion.compare("SAD") == 0){
        if(ePoints<=0){
            emotion = "NEUTRAL";
            ePoints = ePoints*-1+1;
            emotionMsg="Not_sad_update";
        }
        else if(ePoints >= maxLevel) ePoints = maxLevel;
    }
    else if(emotion.compare("NEUTRAL") == 0){
        //If level is lower than 0
        if(ePoints<=0){
            //Choose randomly between angry and sad
            double random = rand();
            if(random > 50){
                emotion = "ANGRY";
                ePoints = -1*ePoints+1;
                emotionMsg="Feel_angry_update";
            }
            else{
                emotion = "SAD";
                ePoints = -1*ePoints+1;
                emotionMsg="Feel_sad_update";
            }
        }
        //If level is greater than 9
        else if(ePoints >= maxLevel){
            //If likeliness is greater than 0 (the robot liked the action)
            if(likelyness > 0){
                //Set emotion to happy
                ePoints = ePoints-maxLevel;
                emotion = "HAPPY";
                emotionMsg="Feel_happy_update";
            }
            //If likeliness is lower than 0 (the robot disliked the action)
            else if(likelyness < 0){
                //Set emotion to angry
                ePoints = ePoints-maxLevel;
                emotion = "ANGRY";
                emotionMsg="Feel_angry_update";
            }
            //Else keep max value
            else ePoints = maxLevel;
        }
    }
    else if(emotion.compare("HAPPY") == 0){
        if(ePoints<=0){
            ePoints = maxLevel+ePoints;
            emotion = "NEUTRAL";
            emotionMsg="Not_happy_update";
        }
        else if(ePoints >= maxLevel) ePoints = maxLevel;
    }

    /*
     * Choose the color of the LEDs depending on the emotion
     */
    //Set a variable with the percentage level of the emotion points, from 1 to 10 to set the intensity
    double newEPoint=ePoints/maxLevel+0.1;
    if(newEPoint>1) newEPoint=1;

    if(emotion.compare("HAPPY") == 0){
    	changeColour(0.0,newEPoint,0.0,"FaceLeds");
    }
    else if(emotion.compare("SAD") == 0){
    	changeColour(0.0,0.0,newEPoint,"FaceLeds");
    }
    else if(emotion.compare("ANGRY") == 0){
    	changeColour(newEPoint,0.0,0.0,"FaceLeds");
    }
    else if(emotion.compare("NEUTRAL") == 0){
    	changeColour(newEPoint,newEPoint,newEPoint,"FaceLeds");
    }

    /*
     * Choose which type of keyWord to send, mood or emotion and then sends a say message with a random dialog related to that keyWord
     */
    //If neither or the messages is empty it chooses randomly
    if(moodMsg.compare("") != 0 && emotionMsg.compare("") != 0){
    	double random = rand();
    	if(random > 50){
    		sayAndWait(chooseRandomDialog(moodMsg));
    	}
    	else sayAndWait(chooseRandomDialog(emotionMsg));
    }
    //If only emotionMsg is not empty it chooses emotionMsg
    else if(emotionMsg.compare("") != 0){
    	sayAndWait(chooseRandomDialog(emotionMsg));
    }
    //If only moodMsg is not empty it chooses moodMsg
    else if(moodMsg.compare("") != 0){
    	sayAndWait(chooseRandomDialog(moodMsg));
    }
}

/*
 * Change the color of the LEDs depending on the r, g, b levels and the name of the LEDs
 */
void StateMachine::changeColour(double r,double g, double b, string name){
    ledMsg.color.r=r;
    ledMsg.color.g=g;
    ledMsg.color.b=b;
    ledMsg.led_name=name;
    led_pub.publish(ledMsg);
}

/*
 * Change state to newState deleting the past state
 */
void StateMachine::transitionTo(AbstractState *newState) {
    if (currentState) {
        cout << "<Leave state "<<currentState->getName()<<">"<< endl <<endl;
        currentState->onLeave();
        delete currentState;
    }
    currentState = newState;
    if (currentState) {
        currentState->sm = this;
        cout << "<State "<<currentState->getName()<<">"<< endl;
        currentState->onEnter();
    }
}

/*
 * Function triggered when the timer launched on WaitInteraction state is out
 * If the robot did not detect an interaction in the timer time it runs an autonomous behavior (From behaviorsList)
 */
void StateMachine::onTimeout(const ros::TimerEvent& event) {
	cout <<endl << "On timeout" << endl;
	//Stop listening
	std_srvs::Empty empty;
	stopRecognitionClient.call(empty.request, empty.response);
	//Stop face tracker
	behaviorClient.cancelGoal();
	behaviorClient.waitForResult(ros::Duration(0.0));

	//Run an autonomous behavior
    autonomousBehaviour();

    //Goes back to WaitInteraction state
	transitionTo(new WaitInteraction());
}

/*
 * Function triggered when the robot detects a release touch on the head
 */
void StateMachine::onTouch(const naoqi_bridge_msgs::TactileTouchConstPtr& msg) {
	cout <<endl << "On touch" << endl;
	//If timer is running
	if(timer.isValid() && msg.get()->statePressed == msg.get()->state){
		//Stop listening
		std_srvs::Empty empty;
		stopRecognitionClient.call(empty.request, empty.response);
		//Stop face tracker
		behaviorClient.cancelGoal();
		behaviorClient.waitForResult(ros::Duration(0.0));
		//Stop timer
		timer.stop();

		//Runs a touched reaction
		touched();

		transitionTo(new WaitInteraction());
	}
}

/*
 * Function triggered when the robot receive the words
 */
void StateMachine::onWordReceived(const naoqi_bridge_msgs::WordRecognizedConstPtr& msg) {
    cout <<endl << "On word received" << endl;
	//Stop listening
	std_srvs::Empty empty;
	stopRecognitionClient.call(empty.request, empty.response);
	//Stop face tracker
	behaviorClient.cancelGoal();
	behaviorClient.waitForResult(ros::Duration(0.0));
	//Stop timer
	timer.stop();
	postureServiceClient.call(posture.request, posture.response);

	//Tuple of the action behavior name, emotion points and mood points
	tuple<string, int, int>  action;
	//If the message of words is not empty
	if (!msg->words.empty()) {
		std::string word = msg->words[0];
		const float confidence = msg->confidence_values[0];

		//Compare the word with the expected ones with 0.4 of confidence
		if(word.compare("sing") == 0 && confidence > 0.4){
			//If it is tired or angry it refuses to do an action and it answer with a dialog from the dialogsList
			if(mood.compare("TIRED") == 0){
				sayAndWait(chooseRandomDialog("Dont_want_tired"));
			}
			else if(emotion.compare("ANGRY") == 0){
				sayAndWait(chooseRandomDialog("Dont_want_angry"));
			}
			else{//Otherwise it choose a random behavior song with the name of the action, emotion and mood
				action=chooseRandomAction("SING"+emotion+mood);

				//Due to the fact that there are not behavior songs on crouch position the robot changes to sitting if it is crouching
				if(posture.response.posture.compare("Crouch") == 0){
					sendGoalAndWait("stiffness/StiffnessOn");
					sendGoalAndWait("ownanimations/SitDown");
					stiffnessOff();
				}//If it is in standing family but not in Stand posture the robot changes it's posture to Stand in case the behavior action needs to be on Stand position
				else if(posture.response.family.compare("Standing") == 0 && posture.response.posture.compare("Stand") != 0){
					sendGoalAndWait("stiffness/StiffnessOn");
					sendGoalAndWait("ownanimations/StandUp");
				}

				//Runs behavior
				sendGoalAndWait(get<0>(action));
				//Add points
				ePoints+=get<1>(action);
				mPoints+=get<2>(action);
			}
		}else if (word.compare("dance")  == 0 && confidence > 0.4){
			if(mood.compare("TIRED") == 0){
				sayAndWait(chooseRandomDialog("Dont_want_tired"));
			}
			else if(emotion.compare("ANGRY") == 0){
				sayAndWait(chooseRandomDialog("Dont_want_angry"));
			}
			else{
				action=chooseRandomAction("DANCE"+emotion+mood);
				sendGoalAndWait("stiffness/StiffnessOn");
				sendGoalAndWait(get<0>(action));
				ePoints+=get<1>(action);
				mPoints+=get<2>(action);
			}
		}else if (word.compare("game")  == 0 && confidence > 0.4){
			if(mood.compare("TIRED") == 0){
				sayAndWait(chooseRandomDialog("Dont_want_tired"));
			}
			else if(emotion.compare("ANGRY") == 0){
				sayAndWait(chooseRandomDialog("Dont_want_angry"));
			}
			else{
				action=chooseRandomAction("GAME"+emotion+mood);
				if(posture.response.posture.compare("Crouch") == 0){
					sendGoalAndWait("stiffness/StiffnessOn");
					sendGoalAndWait("ownanimations/SitDown");
					stiffnessOff();
				}
				else if(posture.response.family.compare("Standing") == 0 && posture.response.posture.compare("Stand") != 0){
					sendGoalAndWait("stiffness/StiffnessOn");
					sendGoalAndWait("ownanimations/StandUp");
				}
				sendGoalAndWait(get<0>(action));
				ePoints+=get<1>(action);
				mPoints+=get<2>(action);
			}
		}

		transitionTo(new WaitInteraction());
	}

}

/*
 * Reacts to touched depending on emotion and mood by using a dialog from dialogsList
 */
void StateMachine::touched() {
	//String of the keysed to get a dialog phrase
	std::string msg;
	//Set likeliness to default
	int likeliness=0;

    if(mood.compare("TIRED") == 0){          //If mood = "mood"
        //If emotion = "emotion"
        if(emotion.compare("ANGRY")==0){
            //Set keyWord
            msg="Dont_touch_touch";
            //Set likeliness
            likeliness=-1;
            //Set new level
            ePoints+=2;
        }
        else if(emotion.compare("SAD")==0){
            msg="Feels_good_touch";
            likeliness=1;
            mPoints-=2;
        }
        else if(emotion.compare("NEUTRAL")==0){
            msg="Feels_good_touch";
            likeliness=1;
            mPoints-=2;
        }
        else if(emotion.compare("HAPPY")==0){
            msg="Feels_good_touch";
            likeliness=1;
            ePoints+=2;
            mPoints-=2;
        }
    }
    else if(mood.compare("BORED")==0){
        if(emotion.compare("ANGRY")==0){
            msg="Dont_touch_touch";
            likeliness=-1;
            ePoints+=2;
        }
        else{
            msg="Sigh_touch";
            likeliness=1;
            mPoints-=2;
        }
    }
    else if(mood.compare("NEUTRAL")==0){
        if(emotion.compare("ANGRY")==0){
            msg="Dont_touch_touch";
            likeliness=-1;
            ePoints+=2;
            mPoints+=2;
        }
        else if(emotion.compare("SAD")==0){
            msg="Feel_better_touch";
            likeliness=1;
            ePoints-=2;
        }
        else if(emotion.compare("HAPPY")==0){
            msg="Laugh_touch";
            likeliness=1;
            ePoints+=2;
            mPoints+=2;
        }
        else if(emotion.compare("NEUTRAL")==0){
            msg="Sigh_touch";
            likeliness=1;
            ePoints+=2;
            mPoints+=4;
        }
    }
    else if(mood.compare("EXCITED")==0){
        if(emotion.compare("ANGRY")==0){
            msg="Dont_touch_touch";
            likeliness=-1;
            ePoints+=2;
            mPoints+=1;
        }
        else if(emotion.compare("SAD")==0){
            msg="Feel_better_touch";
            likeliness=1;
            ePoints-=2;
            mPoints+=2;
        }
        else if(emotion.compare("NEUTRAL")==0){
            msg="Feel_better_touch";
            likeliness=1;
            ePoints+=2;
            mPoints+=2;
        }
        else if(emotion.compare("HAPPY")==0){
            msg="Laugh_touch";
            likeliness=1;
            ePoints+=2;
            mPoints+=2;
        }
    }

    sayAndWait(chooseRandomDialog(msg));
    updateME(likeliness);
}

/*
 * It starts face tracking
 */
void StateMachine::startFaceTracker(){
	std::mt19937 rng;
    rng.seed(std::random_device()());
    std::uniform_int_distribution<std::mt19937::result_type> dist6(5,9);

	naoqi_bridge_msgs::RunBehaviorGoal goal;
	goal.behavior = "robotbehavior/FaceTracker";
	timer = nh.createTimer(ros::Duration(dist6(rng)), &StateMachine::onTimeout, this, true);
	behaviorClient.sendGoal(goal);
}

int main(int argc, char *argv[]) {
    ros::init(argc, argv, "autonomous_life");
    StateMachine dialog;
    ros::spin();
    return 0;
}
