#include <autonomous_life/Behavior.h>

/*
 * It initializes the behaviorsList variable with the BehaviorsList.txt file
 */
void getBehaviorsList(){
    ifstream file("/src/autonomous_life/BehaviorsList.txt");
    if(!file) ifstream file("autonomous_life/BehaviorsList.txt");
    if(!file) ifstream file("BehaviorsList.txt");
    if(!file) cout << "Error getting file" << endl;
    if(file.is_open()){
        string emotionMood;string posture;string behaviorName;int ePoints;int mPoints;

        while (!file.eof( )){
            file >> emotionMood;
            file >> posture;
            file >> behaviorName;
            file >> ePoints;
            file >> mPoints;
			
            behaviorsList.push_back(make_tuple(emotionMood, posture, behaviorName,ePoints,mPoints));
        }
    }
}

/*
 * It initializes the dialogsList variable with the DialogsList.txt file
 */
void getDialogsList(){
    ifstream file("/src/autonomous_life/DialogsList.txt");
    if(!file) ifstream file("autonomous_life/DialogsList.txt");
    if(!file) ifstream file("DialogsList.txt");
    if(!file) cout << "Error getting file" << endl;
    if(file.is_open()){
        string keyWord;string dialog;
        file >> keyWord;
        std::getline(file, dialog);

        while (!file.eof( )){
            dialogsList.push_back(make_tuple(keyWord, dialog));

            file >> keyWord;
            std::getline(file, dialog);
        }
    }
}

/*
 * It initializes the actionsList variable with the ActionsList.txt file
 */
void getActionsList(){
    ifstream file("/src/autonomous_life/ActionsList.txt");
    if(!file) ifstream file("autonomous_life/ActionsList.txt");
    if(!file) ifstream file("ActionsList.txt");
    if(!file) cout << "Error getting file" << endl;
    if(file.is_open()){
        string keyWord;string action;int ePoints;int mPoints;
        file >> keyWord;
        file >> action;
        file >> ePoints;
        file >> mPoints;

        while (!file.eof( )){
        	actionsList.push_back(make_tuple(keyWord, action, ePoints,mPoints));
            file >> keyWord;
            file >> action;
            file >> ePoints;
            file >> mPoints;
        }
    }
}

/*
 * Choose a random behavior from the behaviorsList according to the emotion, mood and robot posture
 * It returns a tuple of behavior name, emotion points and mood points
 */
tuple<string, int, int> chooseRandomBehavior(std::string emotion, std::string mood, std::string posture){
	std::vector<int> posList;
	tuple<string, int, int> behavior;

	if(behaviorsList.size()<=0) getBehaviorsList();

	for(int i=0;i<behaviorsList.size();i++){
        if((get<0>(behaviorsList.at(i)).compare(emotion+mood) == 0 ||
        		get<0>(behaviorsList.at(i)).compare(emotion) == 0 ||
				get<0>(behaviorsList.at(i)).compare(mood) == 0)
        		&& get<1>(behaviorsList.at(i)).compare(posture) == 0){
    		posList.push_back(i);
		}
	}

	if(posList.size()>0){
		std::mt19937 rng;
		rng.seed(std::random_device()());
		std::uniform_int_distribution<std::mt19937::result_type> dist6(0,posList.size()-1);
		int random = dist6(rng);

		return make_tuple(get<2>(behaviorsList.at(posList.at(random))),
							get<3>(behaviorsList.at(posList.at(random))),
							get<4>(behaviorsList.at(posList.at(random))));
	}
	else return make_tuple("",0,0);
}

/*
 * Choose a random dialog from the dialogsList according to a key word
 * It returns a string with the dialog phrase
 */
string chooseRandomDialog(std::string keyWord){
	std::vector<int> posList;

	if(dialogsList.size()<=0) getDialogsList();

	for(int i=0;i<dialogsList.size();i++){
        if(get<0>(dialogsList.at(i)).compare(keyWord) == 0){
    		posList.push_back(i);
		}
	}

	if(posList.size()>0){
		std::mt19937 rng;
		rng.seed(std::random_device()());
		std::uniform_int_distribution<std::mt19937::result_type> dist6(0,posList.size()-1);
		int random = dist6(rng);

		return get<1>(dialogsList.at(posList.at(random)));
	}
	else return "[]";
}

/*
 * Choose a random behavior from the actionsList according to a keyWord
 * It returns a tuple of behavior name, emotion points and mood points
 */
tuple<string, int, int> chooseRandomAction(std::string keyWord){
	std::vector<int> posList;

	if(actionsList.size()<=0) getActionsList();

	for(int i=0;i<actionsList.size();i++){
        if(get<0>(actionsList.at(i)).compare(keyWord) == 0){
    		posList.push_back(i);
		}
	}

	if(posList.size()>0){
		std::mt19937 rng;
		rng.seed(std::random_device()());
		std::uniform_int_distribution<std::mt19937::result_type> dist6(0,posList.size()-1);
		int random = dist6(rng);

		return make_tuple(get<1>(actionsList.at(posList.at(random))),
				get<2>(actionsList.at(posList.at(random))),
				get<3>(actionsList.at(posList.at(random))));
	}
	else return make_tuple("[]",0,0);
}
