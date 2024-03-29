var express = require("express");
var fs = require("fs");
var router = express.Router();
const { v4: uuidv4 } = require("uuid");
const unprocessableEntityResponse = { message: 'Not Found' };
const notFoundResponse = { message: 'Not Found' };
const unauthorizedResponse = { message: 'Unauthorized' };
const badRequestResponse = { message: 'Bad Request' };
const createdResponse = { message: 'Created' };
const okResponse=  { message: 'Ok'};

router.get("/users", (req, res, next) => {
  fs.readFile("../data/users.json", "utf8", (err, data) => {
    if (err) {
      console.log(err);
      return;
    }
    res.setHeader("Content-Type", "application/json");
    res.end(data);
  });
});

router.get("/boards", (req, res, next) => handleRequest(req, res, getBoards));

router.get("/boards/:boardId", (req, res, next) =>
  handleRequest(req, res, getBoardById)
);

router.post("/boards/:boardId/columns/:columnId", (req, res, next) =>
  handleRequest(req, res, createTask)
);

router.put("/boards/:boardId/columns/:columnId", (req, res, next) =>
  handleRequest(req, res, updateColumnColor)
);

router.delete(
  "/boards/:boardId/columns/:columnId/tasks/:taskId",
  (req, res, next) => handleRequest(req, res, deleteTask)
);

router.put(
  "/boards/:boardId/columns/:columnId/tasks/:taskId",
  (req, res, next) => handleRequest(req, res, updateTask)
);

router.post("/boards", (req, res, next) =>
  handleRequest(req, res, createBoard)
);

const createBoard = (req, res, roles, userId) => {
  if (
    !roles.includes("ROLE_USER_WRITE") &&
    !roles.includes("ROLE_ADMIN_WRITE")
  ) {
    res.status(401).end(JSON.stringify(unauthorizedResponse));
    return;
  }

  const board = req.body;
  const colorRegex = /^#([0-9a-f]{3}){1,2}$/i;

  if (!board?.name || typeof board.name !== "string" || board.name.length < 1) {
    res.status(400).end(JSON.stringify(badRequestResponse));
    return;
  }

  if (
    !board?.color ||
    typeof board.color !== "string" ||
    !colorRegex.test(board.color)
  ) {
    res.status(400).end(JSON.stringify(badRequestResponse));
    return;
  }

  board.id = uuidv4();
  board.owner = userId;

  for (const column of board.columns) {
    if (
      !column?.name ||
      typeof column.name !== "string" ||
      column.name.length < 1
    ) {
      res.status(400).end(JSON.stringify(badRequestResponse));
      return;
    }

    if (
      !column?.color ||
      typeof column.color !== "string" ||
      !colorRegex.test(column.color)
    ) {
      res.status(400).end(JSON.stringify(badRequestResponse));
      return;
    }

    column.id = uuidv4();
  }

  fs.readFile("../data/boards.json", "utf8", (err, data) => {
    if (err) {
      console.log(err);

      return;
    }

    const boards = JSON.parse(data);
    boards.push(board);
    const content = JSON.stringify(boards);

    fs.writeFile("../data/boards.json", content, (err) => {
      if (err) console.error(err);

      res.status(201).end(JSON.stringify(createdResponse));
    });
  });
};

const deleteTask = (req, res, roles, userId) => {
  fs.readFile("../data/boards.json", "utf8", (err, data) => {
    if (err) {
      console.log(err);

      return;
    }

    const boards = JSON.parse(data);
    const board =
      boards.filter((board) => board.id === req.params.boardId)[0] ?? null;

    if (!board) {
      res.status(404).end(JSON.stringify(notFoundResponse));
      return;
    }

    if (board.owner === userId || roles.includes("ROLE_ADMIN_WRITE")) {
      const column =
        board.columns.filter(
          (column) => column.id === req.params.columnId
        )[0] ?? null;

      if (!column) {
        res.status(404).end(JSON.stringify(notFoundResponse));
        return;
      }

      if (
        !column.tasks.filter((task) => task.id === req.params.taskId).length
      ) {
        res.status(404).end(JSON.stringify(notFoundResponse));
        return;
      }

      column.tasks = column.tasks.filter(
        (task) => task.id !== req.params.taskId
      );
      const content = JSON.stringify(boards);

      fs.writeFile("../data/boards.json", content, (err) => {
        if (err) console.error(err);

        res.status(200).end(JSON.stringify(okResponse));
      });
    } else {
      res.status(404).end(JSON.stringify(notFoundResponse));
    }
  });
};

const updateTask = (req, res, roles, userId) => {
  fs.readFile("../data/boards.json", "utf8", (err, data) => {
    if (err) {
      console.log(err);

      return;
    }

    const boards = JSON.parse(data);
    const board =
      boards.filter((board) => board.id === req.params.boardId)[0] ?? null;

    if (!board) {
      res.status(404).end(JSON.stringify(notFoundResponse));
      return;
    }

    if (board.owner === userId || roles.includes("ROLE_ADMIN_WRITE")) {
      const column =
        board.columns.filter(
          (column) => column.id === req.params.columnId
        )[0] ?? null;

      if (!column) {
        res.status(404).end(JSON.stringify(notFoundResponse));
        return;
      }

      const task =
        column.tasks.filter((task) => task.id === req.params.taskId)[0] ?? null;

      if (!task) {
        res.status(404).end(JSON.stringify(notFoundResponse));
        return;
      }

      if (
        req.body?.name &&
        typeof req.body.name === "string" &&
        req.body.name.length >= 1
      ) {
        task.name = req.body.name;
      }

      if (req.body?.columnId) {
        const newColumn =
          board.columns.filter(
            (column) => column.id === req.body.columnId
          )[0] ?? null;

        if (!newColumn) {
          res.status(422).end(JSON.stringify(unprocessableEntityResponse));
          return;
        }

        column.tasks = column.tasks.filter(
          (task) => task.id !== req.params.taskId
        );
        newColumn.tasks.push({ id: task.id, name: task.name });
      }

      const content = JSON.stringify(boards);

      fs.writeFile("../data/boards.json", content, (err) => {
        if (err) console.error(err);

        res.status(200).end(JSON.stringify(okResponse));
      });
    } else {
      res.status(404).end(JSON.stringify(notFoundResponse));
    }
  });
};

const getBoardById = (req, res, roles, userId) => {
  fs.readFile("../data/boards.json", "utf8", (err, data) => {
    if (err) {
      console.log(err);

      return;
    }

    const board =
      JSON.parse(data).filter((board) => board.id === req.params.boardId)[0] ??
      null;

    if (!board) {
      res.status(404).end(JSON.stringify(notFoundResponse));
      return;
    }

    if (board.owner === userId || roles.includes("ROLE_ADMIN_READ")) {
      res.end(JSON.stringify(board));
    } else {
      res.status(404).end(JSON.stringify(notFoundResponse));
    }
  });
};

const handleRequest = (req, res, fulfillRequest) => {
  const userId = req.get("x-user-id");

  res.setHeader("Content-Type", "application/json");

  if (!userId) {
    res.status(401).end(JSON.stringify(unauthorizedResponse));
    return;
  }

  fs.readFile("../data/users.json", "utf-8", (err, data) => {
    if (err) {
      console.log(err);

      return;
    }

    const users = JSON.parse(data).filter((user) => user.id === userId);

    if (users.length === 1) {
      const roles = users[0].roles;

      fulfillRequest(req, res, roles, userId);
    } else {
      res.status(401).end(JSON.stringify(unauthorizedResponse));
    }
  });
};

const getBoards = (req, res, roles, userId) => {
  fs.readFile("../data/boards.json", "utf8", (err, data) => {
    if (err) {
      console.log(err);

      return;
    }

    const boards = JSON.parse(data).filter(
      (board) => board.owner === userId || roles.includes("ROLE_ADMIN_READ")
    );

    res.end(JSON.stringify(boards));
  });
};


const updateColumnColor = (req, res, roles, userId) => {
  fs.readFile("../data/boards.json", "utf8", (err, data) => {
    if (err) {
      console.log(err);

      return;
    }

    const boards = JSON.parse(data);
    const board =
      boards.filter((board) => board.id === req.params.boardId)[0] ?? null;

    if (!board) {
      res.status(404).end(JSON.stringify(notFoundResponse));
      return;
    }

    if (board.owner === userId || roles.includes("ROLE_ADMIN_WRITE")) {
      const column =
        board.columns.filter(
          (column) => column.id === req.params.columnId
        )[0] ?? null;

      if (!column) {
        res.status(404).end(JSON.stringify(notFoundResponse));
        return;
      }

      if (
        req.body?.color &&
        typeof req.body.color === "string" &&
        req.body.color.length >= 1
      ) {
        column.color = req.body.color;
      }

      const content = JSON.stringify(boards);

      fs.writeFile("../data/boards.json", content, (err) => {
        if (err) console.error(err);

        res.status(200).end(JSON.stringify(okResponse));
      });
    } else {
      res.status(404).end(JSON.stringify(notFoundResponse));
    }
  });
};

const createTask = (req, res, roles, userId) => {
  if (!req.body?.id || req.body.id.length !== 36) {
    res.status(400).end(JSON.stringify(badRequestResponse));
    return;
  }

  if (
    !req.body?.name ||
    typeof req.body.name !== "string" ||
    req.body.name.length < 1
  ) {
    res.status(400).end(JSON.stringify(badRequestResponse));
    return;
  }

  fs.readFile("../data/boards.json", "utf8", (err, data) => {
    if (err) {
      console.log(err);

      return;
    }

    const boards = JSON.parse(data);
    const board =
      boards.filter((board) => board.id === req.params.boardId)[0] ?? null;

    if (!board) {
      res.status(404).end(JSON.stringify(notFoundResponse));
      return;
    }

    if (board.owner === userId || roles.includes("ROLE_ADMIN_WRITE")) {
      const column =
        board.columns.filter(
          (column) => column.id === req.params.columnId
        )[0] ?? null;

      if (!column) {
        res.status(404).end(JSON.stringify(notFoundResponse));
        return;
      }

      if (column.tasks.filter((task) => task.id === req.body.id).length) {
        res.status(422).end(JSON.stringify(unprocessableEntityResponse));
        return;
      }

      column.tasks.push({
        id: req.body.id,
        name: req.body.name,
      });

      const content = JSON.stringify(boards);

      fs.writeFile("../data/boards.json", content, (err) => {
        if (err) {
          console.error(err);
        }

        res.status(201).end(JSON.stringify(createdResponse));
      });
    } else {
      res.status(404).end(JSON.stringify(notFoundResponse));
    }
  });
};

module.exports = router;
