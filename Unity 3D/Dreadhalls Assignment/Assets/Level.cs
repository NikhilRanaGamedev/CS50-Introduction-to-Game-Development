using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class Level : MonoBehaviour
{
    public static int level = 1;

    // Start is called before the first frame update
    void Start()
    {
        gameObject.GetComponent<Text>().text = "Level: " + level;
    }
}
