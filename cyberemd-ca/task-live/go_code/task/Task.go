// Code generated - DO NOT EDIT.
// This file is a generated binding and any manual changes will be lost.

package task

import (
	"math/big"
	"strings"

	"github.com/FISCO-BCOS/go-sdk/abi"
	"github.com/FISCO-BCOS/go-sdk/abi/bind"
	"github.com/FISCO-BCOS/go-sdk/core/types"
	ethereum "github.com/ethereum/go-ethereum"
	"github.com/ethereum/go-ethereum/common"
)

// Reference imports to suppress errors if they are not otherwise used.
var (
	_ = big.NewInt
	_ = strings.NewReader
	_ = ethereum.NotFound
	_ = abi.U256
	_ = bind.Bind
	_ = common.Big1
)

// TaskTaskData is an auto generated low-level Go binding around an user-defined struct.
type TaskTaskData struct {
	Issuer    common.Address
	Taker     common.Address
	Intro     string
	Comment   string
	Bonus     *big.Int
	Timestamp *big.Int
	Status    uint8
}

// TaskABI is the input ABI used to generate the binding from.
const TaskABI = "[{\"inputs\":[{\"internalType\":\"address\",\"name\":\"_token\",\"type\":\"address\"}],\"stateMutability\":\"nonpayable\",\"type\":\"constructor\"},{\"anonymous\":false,\"inputs\":[{\"indexed\":true,\"internalType\":\"address\",\"name\":\"_issuer\",\"type\":\"address\"},{\"indexed\":true,\"internalType\":\"uint256\",\"name\":\"_index\",\"type\":\"uint256\"},{\"indexed\":false,\"internalType\":\"string\",\"name\":\"_intro\",\"type\":\"string\"},{\"indexed\":false,\"internalType\":\"uint256\",\"name\":\"_bonus\",\"type\":\"uint256\"}],\"name\":\"NewTask\",\"type\":\"event\"},{\"anonymous\":false,\"inputs\":[{\"indexed\":true,\"internalType\":\"address\",\"name\":\"_operator\",\"type\":\"address\"},{\"indexed\":true,\"internalType\":\"uint256\",\"name\":\"_index\",\"type\":\"uint256\"},{\"indexed\":false,\"internalType\":\"enumTask.TaskStatus\",\"name\":\"_status\",\"type\":\"uint8\"}],\"name\":\"TaskUpdate\",\"type\":\"event\"},{\"inputs\":[{\"internalType\":\"uint256\",\"name\":\"_index\",\"type\":\"uint256\"}],\"name\":\"commit\",\"outputs\":[],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"uint256\",\"name\":\"_bonus\",\"type\":\"uint256\"},{\"internalType\":\"string\",\"name\":\"_intro\",\"type\":\"string\"}],\"name\":\"issue\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"\",\"type\":\"uint256\"}],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"address\",\"name\":\"_to\",\"type\":\"address\"}],\"name\":\"register\",\"outputs\":[],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"uint256\",\"name\":\"_index\",\"type\":\"uint256\"},{\"internalType\":\"string\",\"name\":\"_comment\",\"type\":\"string\"},{\"internalType\":\"bool\",\"name\":\"_passed\",\"type\":\"bool\"}],\"name\":\"settled\",\"outputs\":[],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"uint256\",\"name\":\"_index\",\"type\":\"uint256\"}],\"name\":\"take\",\"outputs\":[],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"uint256\",\"name\":\"_index\",\"type\":\"uint256\"}],\"name\":\"task\",\"outputs\":[{\"components\":[{\"internalType\":\"address\",\"name\":\"issuer\",\"type\":\"address\"},{\"internalType\":\"address\",\"name\":\"taker\",\"type\":\"address\"},{\"internalType\":\"string\",\"name\":\"intro\",\"type\":\"string\"},{\"internalType\":\"string\",\"name\":\"comment\",\"type\":\"string\"},{\"internalType\":\"uint256\",\"name\":\"bonus\",\"type\":\"uint256\"},{\"internalType\":\"uint256\",\"name\":\"timestamp\",\"type\":\"uint256\"},{\"internalType\":\"enumTask.TaskStatus\",\"name\":\"status\",\"type\":\"uint8\"}],\"internalType\":\"structTask.TaskData\",\"name\":\"_task\",\"type\":\"tuple\"}],\"stateMutability\":\"view\",\"type\":\"function\"}]"

// Task is an auto generated Go binding around a Solidity contract.
type Task struct {
	TaskCaller     // Read-only binding to the contract
	TaskTransactor // Write-only binding to the contract
	TaskFilterer   // Log filterer for contract events
}

// TaskCaller is an auto generated read-only Go binding around a Solidity contract.
type TaskCaller struct {
	contract *bind.BoundContract // Generic contract wrapper for the low level calls
}

// TaskTransactor is an auto generated write-only Go binding around a Solidity contract.
type TaskTransactor struct {
	contract *bind.BoundContract // Generic contract wrapper for the low level calls
}

// TaskFilterer is an auto generated log filtering Go binding around a Solidity contract events.
type TaskFilterer struct {
	contract *bind.BoundContract // Generic contract wrapper for the low level calls
}

// TaskSession is an auto generated Go binding around a Solidity contract,
// with pre-set call and transact options.
type TaskSession struct {
	Contract     *Task             // Generic contract binding to set the session for
	CallOpts     bind.CallOpts     // Call options to use throughout this session
	TransactOpts bind.TransactOpts // Transaction auth options to use throughout this session
}

// TaskCallerSession is an auto generated read-only Go binding around a Solidity contract,
// with pre-set call options.
type TaskCallerSession struct {
	Contract *TaskCaller   // Generic contract caller binding to set the session for
	CallOpts bind.CallOpts // Call options to use throughout this session
}

// TaskTransactorSession is an auto generated write-only Go binding around a Solidity contract,
// with pre-set transact options.
type TaskTransactorSession struct {
	Contract     *TaskTransactor   // Generic contract transactor binding to set the session for
	TransactOpts bind.TransactOpts // Transaction auth options to use throughout this session
}

// TaskRaw is an auto generated low-level Go binding around a Solidity contract.
type TaskRaw struct {
	Contract *Task // Generic contract binding to access the raw methods on
}

// TaskCallerRaw is an auto generated low-level read-only Go binding around a Solidity contract.
type TaskCallerRaw struct {
	Contract *TaskCaller // Generic read-only contract binding to access the raw methods on
}

// TaskTransactorRaw is an auto generated low-level write-only Go binding around a Solidity contract.
type TaskTransactorRaw struct {
	Contract *TaskTransactor // Generic write-only contract binding to access the raw methods on
}

// NewTask creates a new instance of Task, bound to a specific deployed contract.
func NewTask(address common.Address, backend bind.ContractBackend) (*Task, error) {
	contract, err := bindTask(address, backend, backend, backend)
	if err != nil {
		return nil, err
	}
	return &Task{TaskCaller: TaskCaller{contract: contract}, TaskTransactor: TaskTransactor{contract: contract}, TaskFilterer: TaskFilterer{contract: contract}}, nil
}

// NewTaskCaller creates a new read-only instance of Task, bound to a specific deployed contract.
func NewTaskCaller(address common.Address, caller bind.ContractCaller) (*TaskCaller, error) {
	contract, err := bindTask(address, caller, nil, nil)
	if err != nil {
		return nil, err
	}
	return &TaskCaller{contract: contract}, nil
}

// NewTaskTransactor creates a new write-only instance of Task, bound to a specific deployed contract.
func NewTaskTransactor(address common.Address, transactor bind.ContractTransactor) (*TaskTransactor, error) {
	contract, err := bindTask(address, nil, transactor, nil)
	if err != nil {
		return nil, err
	}
	return &TaskTransactor{contract: contract}, nil
}

// NewTaskFilterer creates a new log filterer instance of Task, bound to a specific deployed contract.
func NewTaskFilterer(address common.Address, filterer bind.ContractFilterer) (*TaskFilterer, error) {
	contract, err := bindTask(address, nil, nil, filterer)
	if err != nil {
		return nil, err
	}
	return &TaskFilterer{contract: contract}, nil
}

// bindTask binds a generic wrapper to an already deployed contract.
func bindTask(address common.Address, caller bind.ContractCaller, transactor bind.ContractTransactor, filterer bind.ContractFilterer) (*bind.BoundContract, error) {
	parsed, err := abi.JSON(strings.NewReader(TaskABI))
	if err != nil {
		return nil, err
	}
	return bind.NewBoundContract(address, parsed, caller, transactor, filterer), nil
}

// Call invokes the (constant) contract method with params as input values and
// sets the output to result. The result type might be a single field for simple
// returns, a slice of interfaces for anonymous returns and a struct for named
// returns.
func (_Task *TaskRaw) Call(opts *bind.CallOpts, result interface{}, method string, params ...interface{}) error {
	return _Task.Contract.TaskCaller.contract.Call(opts, result, method, params...)
}

// Transfer initiates a plain transaction to move funds to the contract, calling
// its default method if one is available.
func (_Task *TaskRaw) Transfer(opts *bind.TransactOpts) (*types.Transaction, *types.Receipt, error) {
	return _Task.Contract.TaskTransactor.contract.Transfer(opts)
}

// Transact invokes the (paid) contract method with params as input values.
func (_Task *TaskRaw) TransactWithResult(opts *bind.TransactOpts, result interface{}, method string, params ...interface{}) (*types.Transaction, *types.Receipt, error) {
	return _Task.Contract.TaskTransactor.contract.TransactWithResult(opts, result, method, params...)
}

// Call invokes the (constant) contract method with params as input values and
// sets the output to result. The result type might be a single field for simple
// returns, a slice of interfaces for anonymous returns and a struct for named
// returns.
func (_Task *TaskCallerRaw) Call(opts *bind.CallOpts, result interface{}, method string, params ...interface{}) error {
	return _Task.Contract.contract.Call(opts, result, method, params...)
}

// Transfer initiates a plain transaction to move funds to the contract, calling
// its default method if one is available.
func (_Task *TaskTransactorRaw) Transfer(opts *bind.TransactOpts) (*types.Transaction, *types.Receipt, error) {
	return _Task.Contract.contract.Transfer(opts)
}

// Transact invokes the (paid) contract method with params as input values.
func (_Task *TaskTransactorRaw) TransactWithResult(opts *bind.TransactOpts, result interface{}, method string, params ...interface{}) (*types.Transaction, *types.Receipt, error) {
	return _Task.Contract.contract.TransactWithResult(opts, result, method, params...)
}

// Task is a free data retrieval call binding the contract method 0x17751a21.
//
// Solidity: function task(uint256 _index) constant returns(TaskTaskData _task)
func (_Task *TaskCaller) Task(opts *bind.CallOpts, _index *big.Int) (TaskTaskData, error) {
	var (
		ret0 = new(TaskTaskData)
	)
	out := ret0
	err := _Task.contract.Call(opts, out, "task", _index)
	return *ret0, err
}

// Task is a free data retrieval call binding the contract method 0x17751a21.
//
// Solidity: function task(uint256 _index) constant returns(TaskTaskData _task)
func (_Task *TaskSession) Task(_index *big.Int) (TaskTaskData, error) {
	return _Task.Contract.Task(&_Task.CallOpts, _index)
}

// Task is a free data retrieval call binding the contract method 0x17751a21.
//
// Solidity: function task(uint256 _index) constant returns(TaskTaskData _task)
func (_Task *TaskCallerSession) Task(_index *big.Int) (TaskTaskData, error) {
	return _Task.Contract.Task(&_Task.CallOpts, _index)
}

// Commit is a paid mutator transaction binding the contract method 0xf4f98ad5.
//
// Solidity: function commit(uint256 _index) returns()
func (_Task *TaskTransactor) Commit(opts *bind.TransactOpts, _index *big.Int) (*types.Transaction, *types.Receipt, error) {
	var ()
	out := &[]interface{}{}
	transaction, receipt, err := _Task.contract.TransactWithResult(opts, out, "commit", _index)
	return transaction, receipt, err
}

func (_Task *TaskTransactor) AsyncCommit(handler func(*types.Receipt, error), opts *bind.TransactOpts, _index *big.Int) (*types.Transaction, error) {
	return _Task.contract.AsyncTransact(opts, handler, "commit", _index)
}

// Commit is a paid mutator transaction binding the contract method 0xf4f98ad5.
//
// Solidity: function commit(uint256 _index) returns()
func (_Task *TaskSession) Commit(_index *big.Int) (*types.Transaction, *types.Receipt, error) {
	return _Task.Contract.Commit(&_Task.TransactOpts, _index)
}

func (_Task *TaskSession) AsyncCommit(handler func(*types.Receipt, error), _index *big.Int) (*types.Transaction, error) {
	return _Task.Contract.AsyncCommit(handler, &_Task.TransactOpts, _index)
}

// Commit is a paid mutator transaction binding the contract method 0xf4f98ad5.
//
// Solidity: function commit(uint256 _index) returns()
func (_Task *TaskTransactorSession) Commit(_index *big.Int) (*types.Transaction, *types.Receipt, error) {
	return _Task.Contract.Commit(&_Task.TransactOpts, _index)
}

func (_Task *TaskTransactorSession) AsyncCommit(handler func(*types.Receipt, error), _index *big.Int) (*types.Transaction, error) {
	return _Task.Contract.AsyncCommit(handler, &_Task.TransactOpts, _index)
}

// Issue is a paid mutator transaction binding the contract method 0x9169d937.
//
// Solidity: function issue(uint256 _bonus, string _intro) returns(uint256)
func (_Task *TaskTransactor) Issue(opts *bind.TransactOpts, _bonus *big.Int, _intro string) (*big.Int, *types.Transaction, *types.Receipt, error) {
	var (
		ret0 = new(*big.Int)
	)
	out := ret0
	transaction, receipt, err := _Task.contract.TransactWithResult(opts, out, "issue", _bonus, _intro)
	return *ret0, transaction, receipt, err
}

func (_Task *TaskTransactor) AsyncIssue(handler func(*types.Receipt, error), opts *bind.TransactOpts, _bonus *big.Int, _intro string) (*types.Transaction, error) {
	return _Task.contract.AsyncTransact(opts, handler, "issue", _bonus, _intro)
}

// Issue is a paid mutator transaction binding the contract method 0x9169d937.
//
// Solidity: function issue(uint256 _bonus, string _intro) returns(uint256)
func (_Task *TaskSession) Issue(_bonus *big.Int, _intro string) (*big.Int, *types.Transaction, *types.Receipt, error) {
	return _Task.Contract.Issue(&_Task.TransactOpts, _bonus, _intro)
}

func (_Task *TaskSession) AsyncIssue(handler func(*types.Receipt, error), _bonus *big.Int, _intro string) (*types.Transaction, error) {
	return _Task.Contract.AsyncIssue(handler, &_Task.TransactOpts, _bonus, _intro)
}

// Issue is a paid mutator transaction binding the contract method 0x9169d937.
//
// Solidity: function issue(uint256 _bonus, string _intro) returns(uint256)
func (_Task *TaskTransactorSession) Issue(_bonus *big.Int, _intro string) (*big.Int, *types.Transaction, *types.Receipt, error) {
	return _Task.Contract.Issue(&_Task.TransactOpts, _bonus, _intro)
}

func (_Task *TaskTransactorSession) AsyncIssue(handler func(*types.Receipt, error), _bonus *big.Int, _intro string) (*types.Transaction, error) {
	return _Task.Contract.AsyncIssue(handler, &_Task.TransactOpts, _bonus, _intro)
}

// Register is a paid mutator transaction binding the contract method 0x4420e486.
//
// Solidity: function register(address _to) returns()
func (_Task *TaskTransactor) Register(opts *bind.TransactOpts, _to common.Address) (*types.Transaction, *types.Receipt, error) {
	var ()
	out := &[]interface{}{}
	transaction, receipt, err := _Task.contract.TransactWithResult(opts, out, "register", _to)
	return transaction, receipt, err
}

func (_Task *TaskTransactor) AsyncRegister(handler func(*types.Receipt, error), opts *bind.TransactOpts, _to common.Address) (*types.Transaction, error) {
	return _Task.contract.AsyncTransact(opts, handler, "register", _to)
}

// Register is a paid mutator transaction binding the contract method 0x4420e486.
//
// Solidity: function register(address _to) returns()
func (_Task *TaskSession) Register(_to common.Address) (*types.Transaction, *types.Receipt, error) {
	return _Task.Contract.Register(&_Task.TransactOpts, _to)
}

func (_Task *TaskSession) AsyncRegister(handler func(*types.Receipt, error), _to common.Address) (*types.Transaction, error) {
	return _Task.Contract.AsyncRegister(handler, &_Task.TransactOpts, _to)
}

// Register is a paid mutator transaction binding the contract method 0x4420e486.
//
// Solidity: function register(address _to) returns()
func (_Task *TaskTransactorSession) Register(_to common.Address) (*types.Transaction, *types.Receipt, error) {
	return _Task.Contract.Register(&_Task.TransactOpts, _to)
}

func (_Task *TaskTransactorSession) AsyncRegister(handler func(*types.Receipt, error), _to common.Address) (*types.Transaction, error) {
	return _Task.Contract.AsyncRegister(handler, &_Task.TransactOpts, _to)
}

// Settled is a paid mutator transaction binding the contract method 0xe5992bbf.
//
// Solidity: function settled(uint256 _index, string _comment, bool _passed) returns()
func (_Task *TaskTransactor) Settled(opts *bind.TransactOpts, _index *big.Int, _comment string, _passed bool) (*types.Transaction, *types.Receipt, error) {
	var ()
	out := &[]interface{}{}
	transaction, receipt, err := _Task.contract.TransactWithResult(opts, out, "settled", _index, _comment, _passed)
	return transaction, receipt, err
}

func (_Task *TaskTransactor) AsyncSettled(handler func(*types.Receipt, error), opts *bind.TransactOpts, _index *big.Int, _comment string, _passed bool) (*types.Transaction, error) {
	return _Task.contract.AsyncTransact(opts, handler, "settled", _index, _comment, _passed)
}

// Settled is a paid mutator transaction binding the contract method 0xe5992bbf.
//
// Solidity: function settled(uint256 _index, string _comment, bool _passed) returns()
func (_Task *TaskSession) Settled(_index *big.Int, _comment string, _passed bool) (*types.Transaction, *types.Receipt, error) {
	return _Task.Contract.Settled(&_Task.TransactOpts, _index, _comment, _passed)
}

func (_Task *TaskSession) AsyncSettled(handler func(*types.Receipt, error), _index *big.Int, _comment string, _passed bool) (*types.Transaction, error) {
	return _Task.Contract.AsyncSettled(handler, &_Task.TransactOpts, _index, _comment, _passed)
}

// Settled is a paid mutator transaction binding the contract method 0xe5992bbf.
//
// Solidity: function settled(uint256 _index, string _comment, bool _passed) returns()
func (_Task *TaskTransactorSession) Settled(_index *big.Int, _comment string, _passed bool) (*types.Transaction, *types.Receipt, error) {
	return _Task.Contract.Settled(&_Task.TransactOpts, _index, _comment, _passed)
}

func (_Task *TaskTransactorSession) AsyncSettled(handler func(*types.Receipt, error), _index *big.Int, _comment string, _passed bool) (*types.Transaction, error) {
	return _Task.Contract.AsyncSettled(handler, &_Task.TransactOpts, _index, _comment, _passed)
}

// Take is a paid mutator transaction binding the contract method 0x4fd9efc4.
//
// Solidity: function take(uint256 _index) returns()
func (_Task *TaskTransactor) Take(opts *bind.TransactOpts, _index *big.Int) (*types.Transaction, *types.Receipt, error) {
	var ()
	out := &[]interface{}{}
	transaction, receipt, err := _Task.contract.TransactWithResult(opts, out, "take", _index)
	return transaction, receipt, err
}

func (_Task *TaskTransactor) AsyncTake(handler func(*types.Receipt, error), opts *bind.TransactOpts, _index *big.Int) (*types.Transaction, error) {
	return _Task.contract.AsyncTransact(opts, handler, "take", _index)
}

// Take is a paid mutator transaction binding the contract method 0x4fd9efc4.
//
// Solidity: function take(uint256 _index) returns()
func (_Task *TaskSession) Take(_index *big.Int) (*types.Transaction, *types.Receipt, error) {
	return _Task.Contract.Take(&_Task.TransactOpts, _index)
}

func (_Task *TaskSession) AsyncTake(handler func(*types.Receipt, error), _index *big.Int) (*types.Transaction, error) {
	return _Task.Contract.AsyncTake(handler, &_Task.TransactOpts, _index)
}

// Take is a paid mutator transaction binding the contract method 0x4fd9efc4.
//
// Solidity: function take(uint256 _index) returns()
func (_Task *TaskTransactorSession) Take(_index *big.Int) (*types.Transaction, *types.Receipt, error) {
	return _Task.Contract.Take(&_Task.TransactOpts, _index)
}

func (_Task *TaskTransactorSession) AsyncTake(handler func(*types.Receipt, error), _index *big.Int) (*types.Transaction, error) {
	return _Task.Contract.AsyncTake(handler, &_Task.TransactOpts, _index)
}

// TaskNewTask represents a NewTask event raised by the Task contract.
type TaskNewTask struct {
	Issuer common.Address
	Index  *big.Int
	Intro  string
	Bonus  *big.Int
	Raw    types.Log // Blockchain specific contextual infos
}

// WatchNewTask is a free log subscription operation binding the contract event 0xcefbef41b0f42f00b8d5e42eca7dc39458a6f13b40807577c67527fe448eb904.
//
// Solidity: event NewTask(address indexed _issuer, uint256 indexed _index, string _intro, uint256 _bonus)
func (_Task *TaskFilterer) WatchNewTask(fromBlock *uint64, handler func(int, []types.Log), _issuer common.Address, _index *big.Int) (string, error) {
	return _Task.contract.WatchLogs(fromBlock, handler, "NewTask", _issuer, _index)
}

func (_Task *TaskFilterer) WatchAllNewTask(fromBlock *uint64, handler func(int, []types.Log)) (string, error) {
	return _Task.contract.WatchLogs(fromBlock, handler, "NewTask")
}

// ParseNewTask is a log parse operation binding the contract event 0xcefbef41b0f42f00b8d5e42eca7dc39458a6f13b40807577c67527fe448eb904.
//
// Solidity: event NewTask(address indexed _issuer, uint256 indexed _index, string _intro, uint256 _bonus)
func (_Task *TaskFilterer) ParseNewTask(log types.Log) (*TaskNewTask, error) {
	event := new(TaskNewTask)
	if err := _Task.contract.UnpackLog(event, "NewTask", log); err != nil {
		return nil, err
	}
	return event, nil
}

// WatchNewTask is a free log subscription operation binding the contract event 0xcefbef41b0f42f00b8d5e42eca7dc39458a6f13b40807577c67527fe448eb904.
//
// Solidity: event NewTask(address indexed _issuer, uint256 indexed _index, string _intro, uint256 _bonus)
func (_Task *TaskSession) WatchNewTask(fromBlock *uint64, handler func(int, []types.Log), _issuer common.Address, _index *big.Int) (string, error) {
	return _Task.Contract.WatchNewTask(fromBlock, handler, _issuer, _index)
}

func (_Task *TaskSession) WatchAllNewTask(fromBlock *uint64, handler func(int, []types.Log)) (string, error) {
	return _Task.Contract.WatchAllNewTask(fromBlock, handler)
}

// ParseNewTask is a log parse operation binding the contract event 0xcefbef41b0f42f00b8d5e42eca7dc39458a6f13b40807577c67527fe448eb904.
//
// Solidity: event NewTask(address indexed _issuer, uint256 indexed _index, string _intro, uint256 _bonus)
func (_Task *TaskSession) ParseNewTask(log types.Log) (*TaskNewTask, error) {
	return _Task.Contract.ParseNewTask(log)
}

// TaskTaskUpdate represents a TaskUpdate event raised by the Task contract.
type TaskTaskUpdate struct {
	Operator common.Address
	Index    *big.Int
	Status   uint8
	Raw      types.Log // Blockchain specific contextual infos
}

// WatchTaskUpdate is a free log subscription operation binding the contract event 0x4c0ce5d7e534c6f1b18ace2e9b45cbdc28ffc3a7b0f45a1f0b528369dd82f75a.
//
// Solidity: event TaskUpdate(address indexed _operator, uint256 indexed _index, uint8 _status)
func (_Task *TaskFilterer) WatchTaskUpdate(fromBlock *uint64, handler func(int, []types.Log), _operator common.Address, _index *big.Int) (string, error) {
	return _Task.contract.WatchLogs(fromBlock, handler, "TaskUpdate", _operator, _index)
}

func (_Task *TaskFilterer) WatchAllTaskUpdate(fromBlock *uint64, handler func(int, []types.Log)) (string, error) {
	return _Task.contract.WatchLogs(fromBlock, handler, "TaskUpdate")
}

// ParseTaskUpdate is a log parse operation binding the contract event 0x4c0ce5d7e534c6f1b18ace2e9b45cbdc28ffc3a7b0f45a1f0b528369dd82f75a.
//
// Solidity: event TaskUpdate(address indexed _operator, uint256 indexed _index, uint8 _status)
func (_Task *TaskFilterer) ParseTaskUpdate(log types.Log) (*TaskTaskUpdate, error) {
	event := new(TaskTaskUpdate)
	if err := _Task.contract.UnpackLog(event, "TaskUpdate", log); err != nil {
		return nil, err
	}
	return event, nil
}

// WatchTaskUpdate is a free log subscription operation binding the contract event 0x4c0ce5d7e534c6f1b18ace2e9b45cbdc28ffc3a7b0f45a1f0b528369dd82f75a.
//
// Solidity: event TaskUpdate(address indexed _operator, uint256 indexed _index, uint8 _status)
func (_Task *TaskSession) WatchTaskUpdate(fromBlock *uint64, handler func(int, []types.Log), _operator common.Address, _index *big.Int) (string, error) {
	return _Task.Contract.WatchTaskUpdate(fromBlock, handler, _operator, _index)
}

func (_Task *TaskSession) WatchAllTaskUpdate(fromBlock *uint64, handler func(int, []types.Log)) (string, error) {
	return _Task.Contract.WatchAllTaskUpdate(fromBlock, handler)
}

// ParseTaskUpdate is a log parse operation binding the contract event 0x4c0ce5d7e534c6f1b18ace2e9b45cbdc28ffc3a7b0f45a1f0b528369dd82f75a.
//
// Solidity: event TaskUpdate(address indexed _operator, uint256 indexed _index, uint8 _status)
func (_Task *TaskSession) ParseTaskUpdate(log types.Log) (*TaskTaskUpdate, error) {
	return _Task.Contract.ParseTaskUpdate(log)
}
