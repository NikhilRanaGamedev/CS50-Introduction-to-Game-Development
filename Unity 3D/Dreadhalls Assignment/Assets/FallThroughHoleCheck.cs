using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class FallThroughHoleCheck : MonoBehaviour {

    public GameObject whisperSource;

    // Update is called once per frame
    void Update()
    {
        if(gameObject.transform.position.y < -50)
        {
            Level.level = 1;
            Destroy(whisperSource);
            SceneManager.LoadScene("Game Over");
        }
    }
}
