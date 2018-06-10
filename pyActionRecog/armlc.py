import os
from sklearn.model_selection import train_test_split

CLASS_MAPPING = {
  "MULTI_TOUCH_NO_STOW": 1,
  "NO_HUMAN": 2,
  "ONE_TOUCH_NO_STOW": 3,
  "MULTI_TOUCH_STOW": 4,
  "NO_TOUCH": 5,
  "ONE_TOUCH_STOW": 6
}

def parse_armlc_splits(frames_path):
  """ generate the train/test split list for armlc2018 data
  Args:
      frames_path -- full path to the root frame directory
  Return:
      [(train_list, test_list), ... ]
      train_list: [(frame_path_basename, label)]

  """  
  full_list = os.listdir(frames_path)
  X = full_list
  y = [parse_label(sample) for sample in full_list]
  X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.33, shuffle=True)

  return [(zip(X_train, y_train), zip(X_test, y_test))]


def parse_label(sample_basename):
  """ return the label for a frame  
    Args:
      sample_basename -- format of <action_name>_uuid
    Return:
      label of the parsed sample
  """
  action_name = sample_basename.split('.')[0]
  return CLASS_MAPPING[action_name]
