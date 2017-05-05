/*
 * GameStateMachine.cpp
 *
 *  Created on: Aug 31, 2016
 *      Author: khalilov
 */
#include <autonomous_life/GameStateMachine.h>

GameStateMachine::GameStateMachine() : currentState(NULL)
{
    /** Start the state machine **/
	gameTransitionTo(new IntroductionState());
}

GameStateMachine::~GameStateMachine()
{
}

void GameStateMachine::gameTransitionTo(AbstractState *newState) {
    if (currentState) {
        currentState->onLeave();
        delete currentState;
    }
    currentState = newState;
    if (currentState) {
        currentState->gsm = this;
        currentState->onEnter();
    }
}

void GameStateMachine::IntroductionState::onEnter()
{
	cout << "Introduction" << endl;
	//say("say something");
	onActionDone();
}

void GameStateMachine::IntroductionState::onActionDone()
{
	/** Start the state machine **/
	gsm->gameTransitionTo(new ListenState());
}

void GameStateMachine::ChooseState::onEnter()
{
}

void GameStateMachine::ChooseState::onActionDone()
{
}

void GameStateMachine::ListenState::onEnter()
{
}

void GameStateMachine::ListenState::onLeave()
{
}

void GameStateMachine::ListenState::onWordReceived(const std::string& msg)
{
}

void GameStateMachine::EndState::onEnter()
{
}

void GameStateMachine::EndState::onActionDone()
{
}
