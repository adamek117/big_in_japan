var express = require('express');
var fs = require('fs');
var router = express.Router();


router.get('/users', function(req, res, next) {
  fs.readFile('data/users.json', 'utf8', function(err, data) {
    if (err) {
      console.log(err);

      return;
    }
    res.setHeader('Content-Type', 'application/json');
    res.end(data);
  });
});

router.get('/boards', function(req, res, next){
  const userId = req.get('x-user-id');

  if(!userId){
    res.status(401).end();
    return;
  } 

  fs.readFile('data/users.json', 'utf-8', function(err, data){
    if(err) {
      console.log(err);

      return;
    }

    const users = JSON.parse(data).filter(user => user.id === userId);

    if(users.length === 1){
      const roles = users[0].roles;

      fs.readFile('data/boards.json', 'utf8', function(err, data){
        if(err) {
          console.log(err);
    
          return;
        }

        res.setHeader('Content-Type', 'application/json');
    
        const boards = JSON.parse(data).filter(board => board.owner === userId || roles.includes('ROLE_ADMIN_READ'));
    
        res.end(JSON.stringify(boards));
      });
    } else {
      res.status(401).end();
    }
  })
})

router.get('/boards/:boardId', function(req, res, next){
  const userId = req.get('x-user-id');

  if(!userId){
    res.status(401).end();
    return;
  }

  fs.readFile('data/users.json', 'utf-8', function(err, data){
    if(err) {
      console.log(err);

      return;
    }

    const users = JSON.parse(data).filter(user => user.id === userId);

    if(users.length === 1){
      const roles = users[0].roles;

      fs.readFile('data/boards.json', 'utf8', function(err, data){
        if(err) {
          console.log(err);
    
          return;
        }

        res.setHeader('Content-Type', 'application/json');
    
        const board = JSON.parse(data).filter(board => board.id === req.params.boardId)[0] ?? {};

        if (board.owner === userId || roles.includes('ROLE_ADMIN_READ')) {
          res.end(JSON.stringify(board));
        } else {
          res.status(404).end();
        }
      })
    } else {
      res.status(401).end();
    }
  });
})

module.exports = router;
