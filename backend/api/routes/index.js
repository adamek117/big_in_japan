var express = require('express');
var fs = require('fs');
var router = express.Router();


router.get('/users', (req, res, next) => {
  fs.readFile('data/users.json', 'utf8', (err, data) => {
    if (err) {
      console.log(err);

      return;
    }
    res.setHeader('Content-Type', 'application/json');
    res.end(data);
  });
});


router.get('/boards', (req, res, next) => handleRequest(req, res, getBoards))

router.get('/boards/:boardId', (req, res, next) => handleRequest(req, res, getBoardById))

router.post('/boards/:boardId/columns/:columnId', (req, res, next) => handleRequest(req, res, createTask))

const getBoardById = (req, res, roles, userId) => {
  fs.readFile('data/boards.json', 'utf8', (err, data) => {
    if(err) {
      console.log(err);

      return;
    }

    const board = JSON.parse(data).filter(board => board.id === req.params.boardId)[0] ?? {};

    if (board.owner === userId || roles.includes('ROLE_ADMIN_READ')) {
      res.end(JSON.stringify(board));
    } else {
      res.status(404).end();
    }
  })
}

const handleRequest = (req, res, fulfillRequest) => {
  const userId = req.get('x-user-id');

  res.setHeader('Content-Type', 'application/json');

  if(!userId){
    res.status(401).end();
    return;
  }

  fs.readFile('data/users.json', 'utf-8', (err, data) => {
    if(err) {
      console.log(err);

      return;
    }

    const users = JSON.parse(data).filter(user => user.id === userId);

    if(users.length === 1){
      const roles = users[0].roles;

     fulfillRequest(req, res, roles, userId);
    } else {
      res.status(401).end();
    }
  });
}

const getBoards = (req, res, roles, userId) => {
  fs.readFile('data/boards.json', 'utf8', (err, data) => {
    if(err) {
      console.log(err);

      return;
    }

    const boards = JSON.parse(data).filter(board => board.owner === userId || roles.includes('ROLE_ADMIN_READ'));

    res.end(JSON.stringify(boards));
  });
}

const createTask = (req, res, roles, userId) => {
  if(!req.body?.id || req.body.id.length !== 36){
    res.status(400).end();
    return;
  }

  if(!req.body?.name || typeof req.body.name !== 'string' || req.body.name.length < 1){
    res.status(400).end();
    return;
  }

  fs.readFile('data/boards.json', 'utf8', (err, data) => {
    if(err) {
      console.log(err);

      return;
    }

    const boards = JSON.parse(data);
    const board = boards.filter(board => board.id === req.params.boardId)[0] ?? null;

    if(!board){
      res.status(404).end();
      return;
    }

    if (board.owner === userId || roles.includes('ROLE_ADMIN_WRITE')) {
      const column = board.columns.filter(column => column.id === req.params.columnId)[0] ?? null;

      if(!column){
        res.status(404).end();
        return;
      }

      if(column.tasks.filter(task => task.id === req.body.id).length){
        res.status(422).end();
        return;
      }
      
      column.tasks.push({
        id: req.body.id,
        name: req.body.name
      })

      const content = JSON.stringify(boards);

      fs.writeFile('data/boards.json', content, err => {
        if (err) {
          console.error(err);
        }
        
        res.status(201).end();  
      });
    } else {
      res.status(404).end();
    }
  })
}

module.exports = router;
