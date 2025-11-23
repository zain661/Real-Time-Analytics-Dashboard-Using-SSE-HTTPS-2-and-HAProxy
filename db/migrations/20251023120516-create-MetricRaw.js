"use strict";
/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.createTable("MetricRaws", {
      id: {
        type: Sequelize.BIGINT,
        autoIncrement: true,
        primaryKey: true,
      },
      server_id: {
        type: Sequelize.STRING(36),
        allowNull: false,
        references: {
          model: "Servers",
          key: "id",
        },
        onDelete: "CASCADE",
      },
      metric_name: {
        type: Sequelize.STRING(100),
        allowNull: false,
      },
      value: {
        type: Sequelize.DOUBLE,
        allowNull: false,
      },
      labels: {
        type: Sequelize.JSON,
        allowNull: true,
      },
      ts: {
        type: Sequelize.DATE(6),
        allowNull: false,
      },
      created_at: {
        type: Sequelize.DATE,
        defaultValue: Sequelize.NOW,
      },
      updated_at: {
        type: Sequelize.DATE,
        defaultValue: Sequelize.NOW,
      },
      deleted_at: {
        type: Sequelize.DATE,
        allowNull: true,
      },
    });

    // Add indexes
    await queryInterface.addIndex("MetricRaws", [
      "server_id",
      "metric_name",
      "ts",
    ]);
    await queryInterface.addIndex("MetricRaws", ["ts"]);
  },

  async down(queryInterface) {
    await queryInterface.dropTable("MetricRaws");
  },
};
