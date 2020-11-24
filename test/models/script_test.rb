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
end
