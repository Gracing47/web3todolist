// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract TodoList is Ownable {

  struct TodoItem {
    string title;
    bool completed;
    uint256 dueDate;
    string priority;
  }

  mapping(address => TodoItem[]) private todos;
  address[] public owners;

  constructor(address owner) Ownable(owner) {
    owners.push(owner);
  }

  function addTodoItem(string memory title, uint256 dueDate, string memory priority) public {
    todos[msg.sender].push(TodoItem({
      title: title,
      completed: false,
      dueDate: dueDate,
      priority: priority
    }));
  }

  function markTodoItemCompleted(uint256 index) public {
    require(index < todos[msg.sender].length, "Invalid index");
    todos[msg.sender][index].completed = true;
  }

  function deleteTodoItem(uint256 index) public {
    require(index < todos[msg.sender].length, "Invalid index");
    for (uint256 i = index; i < todos[msg.sender].length - 1; i++) {
      todos[msg.sender][i] = todos[msg.sender][i + 1];
    }
    todos[msg.sender].pop();
  }

  function inviteAddress(address newOwner) public onlyOwner {
    require(newOwner != address(0), "Invalid address");
    owners.push(newOwner);
  }

  function getAllTodoItems() public view returns (TodoItem[] memory) {
    return todos[msg.sender];
  }

  function getTodoItem(uint256 index) public view returns (TodoItem memory) {
    require(index < todos[msg.sender].length, "Invalid index");
    return todos[msg.sender][index];
  }

  function getOwners() public view returns (address[] memory) {
    return owners;
  }
}
