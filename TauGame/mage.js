{
  "mage": {
    "shape": {
      "geometry": "triangle",
      "vertex0": [0.0, -2.0],
      "vertex1": [1.0, 0.0],
      "vertex2": [-1.0, 0.0],
      "color": [0.0, 0.082, 0.416, 1.0]
    },
    "scale": 2.0,
    "children": {
      "head": {
        "shape": {
          "geometry": "circle",
          "color": [0.0, 0.0, 0.0, 1.0],
          "scale": 0.65
        },
        "translation": [0.0, 0.45],
        "children": {
          "hat": {
            "shape": {
              "geometry": "triangle",
              "vertex0": [0.0, 0.6],
              "vertex1": [1.0, 0.0],
              "vertex2": [-1.0, 0.0],
              "color": [0.812, 0.455, 0.11, 1.0]
            },
            "translation": [0.0, 0.45]
          },
          "eyes": {
            "translation": [0.0, 0.1],
            "children": {
              "left eye": {
                "shape": {
                  "geometry": "rectangle",
                  "width": 0.1,
                  "height": 0.25,
                  "color": [0.812, 0.455, 0.11, 1.0],
                  "translation": [-0.2, 0.0]
                }
              },
              "right eye": {
                "shape": {
                  "geometry": "rectangle",
                  "width": 0.1,
                  "height": 0.25,
                  "color": [0.812, 0.455, 0.11, 1.0],
                  "translation": [0.2, 0.0]
                }
              }
            }
          }
        }
      },
      "hands": {
        "translation": [0.0, -0.5],
        "children": {
          "left hand": {
            "shape": {
              "geometry": "rectangle",
              "width": 0.5,
              "height": 0.75,
              "color": [0.812, 0.455, 0.11, 1.0],
              "translation": [-2.5, 0.0],
              "scale": 0.5
            }
          },
          "right hand": {
            "shape": {
              "geometry": "rectangle",
              "width": 0.5,
              "height": 0.75,
              "color": [0.812, 0.455, 0.11, 1.0],
              "translation": [2.5, 0.0],
              "scale": 0.5
            }
          }
        }
      }  
    }
  }
}