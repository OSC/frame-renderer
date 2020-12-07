require 'test_helper'

class ScriptTest < ActiveSupport::TestCase

  test "task frames from one node starting at 1" do
    script = Script.new(frames: '1-10', nodes: '1')
    assert_equal [1], script.task_start_frames
    assert_equal [10], script.task_end_frames
  end

  test "task frames from one node starting at 0" do
    script = Script.new(frames: '0-10', nodes: '1')
    assert_equal [0], script.task_start_frames
    assert_equal [10], script.task_end_frames
  end

  test "task frames evenly spit across many nodes starting from 1" do
    script = Script.new(frames: '1-30', nodes: '3')
    assert_equal [1, 11, 21], script.task_start_frames
    assert_equal [10, 20, 30], script.task_end_frames
  end

  test "task frames evenly spit across many nodes starting from 0" do
    script = Script.new(frames: '0-30', nodes: '3')
    assert_equal [0, 10, 20], script.task_start_frames
    assert_equal [9, 19, 30], script.task_end_frames
  end

  test "task frames un-evenly spit across many nodes starting from 1" do
    script = Script.new(frames: '1-50', nodes: '3')
    assert_equal [1, 17, 33], script.task_start_frames
    assert_equal [16, 32, 50], script.task_end_frames
  end

  test "task frames un-evenly spit across many nodes starting from 0" do
    script = Script.new(frames: '0-50', nodes: '3')
    assert_equal [0, 17, 34], script.task_start_frames
    assert_equal [16, 33, 50], script.task_end_frames
  end

  test "task frames when nodes and frames are the same. starting from 0" do
    script = Script.new(frames: '0-5', nodes: '6')
    assert_equal [0, 1, 2, 3, 4, 5], script.task_start_frames
    assert_equal [0, 1, 2, 3, 4, 5], script.task_end_frames
  end

  test "task frames when nodes and frames are the same. starting from 1" do
    script = Script.new(frames: '1-5', nodes: '5')
    assert_equal [1, 2, 3, 4, 5], script.task_start_frames
    assert_equal [1, 2, 3, 4, 5], script.task_end_frames
  end

  test "task frame remainders work when nodes are almost equal tasks starting from 0" do
    script = Script.new(frames: '0-10', nodes: '10')
    assert_equal [0, 1, 2, 3, 4, 5, 6, 7, 8, 9], script.task_start_frames
    assert_equal [0, 1, 2, 3, 4, 5, 6, 7, 8, 10], script.task_end_frames
  end

  test "task frame remainders work when nodes are almost equal tasks starting from 1" do
    script = Script.new(frames: '1-10', nodes: '9')
    assert_equal [1, 2, 3, 4, 5, 6, 7, 8, 9], script.task_start_frames
    assert_equal [1, 2, 3, 4, 5, 6, 7, 8, 10], script.task_end_frames
  end

  test "task frames starting from >> 1 with 1 node" do
    script = Script.new(frames: '101-200', nodes: '1')
    assert_equal [101], script.task_start_frames
    assert_equal [200], script.task_end_frames
  end

  test "task frames starting from >> 1 with 4 nodes" do
    script = Script.new(frames: '101-200', nodes: '4')
    assert_equal [101, 126, 151, 176], script.task_start_frames
    assert_equal [125, 150, 175, 200], script.task_end_frames
  end

  test "task frames starting from >> 1 with many nodes" do
    script = Script.new(frames: '254-10034', nodes: '15')
    assert_equal [254, 906, 1558, 2210, 2862, 3514, 4166, 4818, 5470, 6122, 6774, 7426, 8078, 8730, 9382], script.task_start_frames
    assert_equal [905, 1557, 2209, 2861, 3513, 4165, 4817, 5469, 6121, 6773, 7425, 8077, 8729, 9381, 10034], script.task_end_frames
  end

  test "task size is 2 but numbered start - end is only 1" do
    script = Script.new(frames: '1-20', nodes: '10')
    assert_equal [1, 3, 5, 7, 9, 11, 13, 15, 17, 19], script.task_start_frames
    assert_equal [2, 4, 6, 8, 10, 12, 14, 16, 18, 20], script.task_end_frames
  end

  test "task size is 2 but numbered start - end is only 1 starting from 0" do
    script = Script.new(frames: '0-20', nodes: '10')
    assert_equal [0, 2, 4, 6, 8, 10, 12, 14, 16, 18], script.task_start_frames
    assert_equal [1, 3, 5, 7, 9, 11, 13, 15, 17, 20], script.task_end_frames
  end
end
