-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `mydb` DEFAULT CHARACTER SET utf8 ;
USE `mydb` ;

-- -----------------------------------------------------
-- Table `mydb`.`Roles`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Roles` (
  `idRoles` INT NOT NULL AUTO_INCREMENT,
  `nom_role` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idRoles`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Users`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Users` (
  `idUsers` INT NOT NULL AUTO_INCREMENT,
  `nom` VARCHAR(45) NOT NULL,
  `prenom` VARCHAR(45) NOT NULL,
  `email` VARCHAR(255) NOT NULL,
  `mdp` VARCHAR(255) NOT NULL,
  `photo_profil` VARCHAR(45) NOT NULL,
  `bio` VARCHAR(45) NULL,
  `ville` VARCHAR(45) NOT NULL,
  `avis` INT NULL,
  `Roles_idRoles` INT NOT NULL,
  PRIMARY KEY (`idUsers`),
  INDEX `fk_Users_Roles_idx` (`Roles_idRoles` ASC) VISIBLE,
  CONSTRAINT `fk_Users_Roles`
    FOREIGN KEY (`Roles_idRoles`)
    REFERENCES `mydb`.`Roles` (`idRoles`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Botaniste`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Botaniste` (
  `idBotaniste` INT NOT NULL AUTO_INCREMENT,
  `siret` INT NOT NULL,
  `nom_entreprise` VARCHAR(45) NOT NULL,
  `adresse_entreprise` VARCHAR(255) NOT NULL,
  `num_entreprise` INT(10) NOT NULL,
  `Users_idUsers` INT NOT NULL,
  PRIMARY KEY (`idBotaniste`),
  INDEX `fk_Botaniste_Users1_idx` (`Users_idUsers` ASC) VISIBLE,
  CONSTRAINT `fk_Botaniste_Users1`
    FOREIGN KEY (`Users_idUsers`)
    REFERENCES `mydb`.`Users` (`idUsers`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Photos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Photos` (
  `idPhotos` INT NOT NULL AUTO_INCREMENT,
  `url_photo` LONGTEXT NOT NULL,
  `Users_idUsers` INT NOT NULL,
  PRIMARY KEY (`idPhotos`),
  INDEX `fk_Photos_Users1_idx` (`Users_idUsers` ASC) VISIBLE,
  CONSTRAINT `fk_Photos_Users1`
    FOREIGN KEY (`Users_idUsers`)
    REFERENCES `mydb`.`Users` (`idUsers`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Annonces`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Annonces` (
  `idAnnonces` INT NOT NULL AUTO_INCREMENT,
  `date_publication` DATETIME NOT NULL,
  `text_annonce` VARCHAR(255) NOT NULL,
  `date_debut` DATE NOT NULL,
  `date_fin` DATE NOT NULL,
  `titre_annonce` VARCHAR(45) NOT NULL,
  `statut` VARCHAR(45) NOT NULL,
  `Users_idUsers` INT NOT NULL,
  PRIMARY KEY (`idAnnonces`),
  INDEX `fk_Annonces_Users1_idx` (`Users_idUsers` ASC) VISIBLE,
  CONSTRAINT `fk_Annonces_Users1`
    FOREIGN KEY (`Users_idUsers`)
    REFERENCES `mydb`.`Users` (`idUsers`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Annonces_has_Photos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Annonces_has_Photos` (
  `Annonces_idAnnonces` INT NOT NULL,
  `Photos_idPhotos` INT NOT NULL,
  PRIMARY KEY (`Annonces_idAnnonces`, `Photos_idPhotos`),
  INDEX `fk_Annonces_has_Photos_Photos1_idx` (`Photos_idPhotos` ASC) VISIBLE,
  INDEX `fk_Annonces_has_Photos_Annonces1_idx` (`Annonces_idAnnonces` ASC) VISIBLE,
  CONSTRAINT `fk_Annonces_has_Photos_Annonces1`
    FOREIGN KEY (`Annonces_idAnnonces`)
    REFERENCES `mydb`.`Annonces` (`idAnnonces`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Annonces_has_Photos_Photos1`
    FOREIGN KEY (`Photos_idPhotos`)
    REFERENCES `mydb`.`Photos` (`idPhotos`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Commentaires_users`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Commentaires_users` (
  `idCommentaires` INT NOT NULL AUTO_INCREMENT,
  `text_commentaire` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`idCommentaires`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Commentaire_photo`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Commentaire_photo` (
  `idCommentaire_photo` INT NOT NULL AUTO_INCREMENT,
  `Commentaire_photo` LONGTEXT NOT NULL,
  `Users_idUsers` INT NOT NULL,
  `Photos_idPhotos` INT NOT NULL,
  PRIMARY KEY (`idCommentaire_photo`),
  INDEX `fk_Commentaire_photo_Users1_idx` (`Users_idUsers` ASC) VISIBLE,
  INDEX `fk_Commentaire_photo_Photos1_idx` (`Photos_idPhotos` ASC) VISIBLE,
  CONSTRAINT `fk_Commentaire_photo_Users1`
    FOREIGN KEY (`Users_idUsers`)
    REFERENCES `mydb`.`Users` (`idUsers`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Commentaire_photo_Photos1`
    FOREIGN KEY (`Photos_idPhotos`)
    REFERENCES `mydb`.`Photos` (`idPhotos`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Commentaires_users_has_Users`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Commentaires_users_has_Users` (
  `Commentaires_users_idCommentaires` INT NOT NULL,
  `Users_idUsers` INT NOT NULL,
  PRIMARY KEY (`Commentaires_users_idCommentaires`, `Users_idUsers`),
  INDEX `fk_Commentaires_users_has_Users_Users1_idx` (`Users_idUsers` ASC) VISIBLE,
  INDEX `fk_Commentaires_users_has_Users_Commentaires_users1_idx` (`Commentaires_users_idCommentaires` ASC) VISIBLE,
  CONSTRAINT `fk_Commentaires_users_has_Users_Commentaires_users1`
    FOREIGN KEY (`Commentaires_users_idCommentaires`)
    REFERENCES `mydb`.`Commentaires_users` (`idCommentaires`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Commentaires_users_has_Users_Users1`
    FOREIGN KEY (`Users_idUsers`)
    REFERENCES `mydb`.`Users` (`idUsers`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
