using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class LoadSceneOnInput : MonoBehaviour {

	Scene currentScene;
	string sceneName;

	// Use this for initialization
	void Start () {
		currentScene = SceneManager.GetActiveScene();
		sceneName = currentScene.name;
	}
	
	// Update is called once per frame
	void Update () {
		if (Input.GetAxis("Submit") == 1) {
			if (sceneName == "Title")
			{
				SceneManager.LoadScene("Play");
			}
			else
			{
				SceneManager.LoadScene("Title");
			}
		}
	}
}
